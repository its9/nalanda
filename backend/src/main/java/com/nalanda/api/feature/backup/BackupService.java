package com.nalanda.api.feature.backup;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.ResultSet;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Service;

import com.nalanda.api.common.ResourceNotFoundException;

@Service
public class BackupService {

    private final JdbcTemplate jdbc;
    private volatile BackupSettingsResponse settings = new BackupSettingsResponse(
            System.getenv().getOrDefault("BACKUP_PATH", "./backups"), false, "DAILY", "23:00", 30);

    public BackupService(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public List<String> drives() {
        List<String> drives = new ArrayList<>(java.util.Arrays.stream(File.listRoots()).map(File::getAbsolutePath).toList());
        Path volumes = Path.of("/Volumes");
        if (Files.isDirectory(volumes)) {
            try (var entries = Files.list(volumes)) {
                entries.filter(Files::isDirectory).map(Path::toString).sorted().forEach(drives::add);
            } catch (IOException ignored) {
                // Keep the root drives when mounted-volume discovery is unavailable.
            }
        }
        return drives;
    }

    public BackupSettingsResponse settings() {
        return settings;
    }

    public BackupSettingsResponse updateSettings(BackupSettingsRequest request) {
        settings = new BackupSettingsResponse(request.backupPath(), request.automaticBackup(),
                request.frequency(), request.time(), request.retentionDays());
        return settings;
    }

    public BackupActionResponse test() {
        try {
            Path path = Path.of(settings.backupPath());
            Files.createDirectories(path);
            return action(null, "TEST", Files.isWritable(path) ? "AVAILABLE" : "NOT_WRITABLE");
        } catch (IOException | RuntimeException exception) {
            return action(null, "TEST", "UNAVAILABLE");
        }
    }

    public BackupResponse create() {
        try {
            Path directory = Path.of(settings.backupPath());
            Files.createDirectories(directory);
            Path file = directory.resolve("bel-training-" + System.currentTimeMillis() + ".sql");
            runDump(file);
            long size = Files.size(file);
                KeyHolder keyHolder = new GeneratedKeyHolder();
                jdbc.update(connection -> {
                var statement = connection.prepareStatement(
                    "INSERT INTO backup_history (backup_path, file_size, status, remarks) VALUES (?, ?, 'SUCCESS', 'MySQL dump created')",
                    new String[] { "id" });
                statement.setString(1, file.toString());
                statement.setLong(2, size);
                return statement;
                }, keyHolder);
                return get(keyHolder.getKey().longValue());
        } catch (IOException exception) {
            throw new IllegalStateException("Backup could not be created: " + exception.getMessage(), exception);
        }
    }

    public BackupListResponse history() {
        List<BackupResponse> items = jdbc.query(
                "SELECT id, backup_path, status, backup_date, COALESCE(file_size, 0) FROM backup_history ORDER BY id DESC",
                this::map);
        return new BackupListResponse(items, items.size());
    }

    public BackupResponse get(Long id) {
        return jdbc.query("SELECT id, backup_path, status, backup_date, COALESCE(file_size, 0) FROM backup_history WHERE id = ?",
                this::map, id).stream().findFirst()
                .orElseThrow(() -> new ResourceNotFoundException("Backup not found: " + id));
    }

    public BackupActionResponse restore(Long id) {
        BackupResponse backup = get(id);
        try {
            Path file = Path.of(backup.backupPath());
            if (!Files.isRegularFile(file)) {
                return action(id, "RESTORE", "NOT_FOUND");
            }
            runRestore(file);
            return action(id, "RESTORE", "COMPLETED");
        } catch (IOException exception) {
            return action(id, "RESTORE", "FAILED");
        }
    }

    public BackupActionResponse verify(Long id) {
        BackupResponse backup = get(id);
        try {
            return action(id, "VERIFY", Files.isRegularFile(Path.of(backup.backupPath())) ? "VALID" : "MISSING");
        } catch (RuntimeException exception) {
            return action(id, "VERIFY", "INVALID");
        }
    }

    private void runDump(Path file) throws IOException {
        runMysqlCommand(List.of("mysqldump", "--single-transaction", "--routines", "--triggers",
                "--result-file=" + file, "--host=" + databaseHost(), "--port=" + databasePort(),
                "--user=" + databaseUser(), databaseName()));
    }

    private void runRestore(Path file) throws IOException {
        ProcessBuilder builder = new ProcessBuilder("mysql", "--host=" + databaseHost(),
                "--port=" + databasePort(), "--user=" + databaseUser(), databaseName());
        addPassword(builder);
        builder.redirectInput(file.toFile());
        builder.redirectErrorStream(true);
        Process process = builder.start();
        try {
            if (process.waitFor() != 0) {
                throw new IOException("mysql restore exited with code " + process.exitValue());
            }
        } catch (InterruptedException exception) {
            Thread.currentThread().interrupt();
            throw new IOException("mysql restore was interrupted", exception);
        }
    }

    private void runMysqlCommand(List<String> command) throws IOException {
        ProcessBuilder builder = new ProcessBuilder(new ArrayList<>(command));
        addPassword(builder);
        builder.redirectErrorStream(true);
        Process process = builder.start();
        try {
            if (process.waitFor() != 0) {
                throw new IOException("mysqldump exited with code " + process.exitValue());
            }
        } catch (InterruptedException exception) {
            Thread.currentThread().interrupt();
            throw new IOException("mysqldump was interrupted", exception);
        }
    }

    private void addPassword(ProcessBuilder builder) {
        String password = System.getenv().getOrDefault("DB_PASSWORD", "");
        if (!password.isBlank()) builder.environment().put("MYSQL_PWD", password);
    }

    private String databaseHost() { return System.getenv().getOrDefault("DB_HOST", "localhost"); }
    private String databasePort() { return System.getenv().getOrDefault("DB_PORT", "3306"); }
    private String databaseUser() { return System.getenv().getOrDefault("DB_USERNAME", "root"); }
    private String databaseName() { return System.getenv().getOrDefault("DB_NAME", "bel_training_management"); }

    private BackupResponse map(ResultSet result, int rowNumber) throws java.sql.SQLException {
        return new BackupResponse(result.getLong(1), result.getString(2), result.getString(3),
                result.getTimestamp(4).toInstant(), result.getLong(5));
    }

    private BackupActionResponse action(Long id, String action, String status) {
        return new BackupActionResponse(id, action, status, Instant.now());
    }
}