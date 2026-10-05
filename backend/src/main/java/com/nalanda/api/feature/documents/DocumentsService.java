package com.nalanda.api.feature.documents;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.PreparedStatement;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.nalanda.api.common.ResourceNotFoundException;

@Service
public class DocumentsService {

    private final JdbcTemplate jdbc;

    public DocumentsService(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public DocumentListResponse list() {
        List<StoredDocument> documents = jdbc.query(selectSql(), this::map);
        return new DocumentListResponse(documents.stream().map(StoredDocument::response).toList(), documents.size());
    }

    public DocumentListResponse byProgram(Long programId) {
        List<StoredDocument> documents = jdbc.query(selectSql() + " WHERE d.program_id = ? ORDER BY d.id", this::map, programId);
        return new DocumentListResponse(documents.stream().map(StoredDocument::response).toList(), documents.size());
    }

    public DocumentResponse upload(MultipartFile file, Long programId, String folderName) {
        if (file == null || file.isEmpty()) throw new IllegalArgumentException("A document file is required");
        if (programId == null || jdbc.queryForObject("SELECT COUNT(*) FROM programs WHERE id = ?", Integer.class, programId) == 0) {
            throw new ResourceNotFoundException("Program not found: " + programId);
        }
        try {
            String filename = safeFilename(file.getOriginalFilename());
            Path folder = programDocumentsFolder(programId, folderName);
            Files.createDirectories(folder);
            Path path = folder.resolve(filename);
            Files.write(path, file.getBytes());
                KeyHolder keyHolder = new GeneratedKeyHolder();
                jdbc.update(connection -> {
                PreparedStatement statement = connection.prepareStatement(
                    "INSERT INTO documents (program_id, file_name, file_path, file_type) VALUES (?, ?, ?, ?)",
                    new String[] { "id" });
                statement.setLong(1, programId);
                statement.setString(2, filename);
                statement.setString(3, path.toString());
                statement.setString(4, file.getContentType());
                return statement;
                }, keyHolder);
                Long id = keyHolder.getKey().longValue();
            return new DocumentResponse(id, programId, filename, file.getContentType(), file.getSize(),
                    jdbc.queryForObject("SELECT uploaded_at FROM documents WHERE id = ?", java.sql.Timestamp.class, id).toInstant(),
                    folder.getFileName().toString());
        } catch (IOException exception) {
            throw new IllegalStateException("Could not store uploaded document", exception);
        }
    }

    public DocumentResponse get(Long id) {
        return findStored(id).response();
    }

    public DocumentDownload download(Long id) {
        StoredDocument document = findStored(id);
        try {
            return new DocumentDownload(document.response().filename(), document.response().contentType(), Files.readAllBytes(Path.of(document.path())));
        } catch (IOException exception) {
            throw new IllegalStateException("Could not read document", exception);
        }
    }

    public void delete(Long id) {
        StoredDocument document = findStored(id);
        jdbc.update("DELETE FROM documents WHERE id = ?", id);
        try {
            Files.deleteIfExists(Path.of(document.path()));
        } catch (IOException exception) {
            throw new IllegalStateException("Could not delete document file", exception);
        }
    }

    public DocumentResponse rename(Long id, String filename) {
        StoredDocument current = findStored(id);
        String nextName = safeFilename(filename);
        if (nextName.isBlank() || nextName.equals("document")) {
            throw new IllegalArgumentException("A valid file name is required");
        }

        Path currentPath = Path.of(current.path());
        Path nextPath = currentPath.resolveSibling(nextName);
        if (!nextPath.getParent().equals(currentPath.getParent())) {
            throw new IllegalArgumentException("Invalid file name");
        }
        if (Files.exists(nextPath) && !currentPath.equals(nextPath)) {
            throw new IllegalArgumentException("A file with this name already exists");
        }

        try {
            Files.move(currentPath, nextPath, java.nio.file.StandardCopyOption.REPLACE_EXISTING);
        } catch (IOException exception) {
            throw new IllegalStateException("Could not rename document", exception);
        }

        jdbc.update("UPDATE documents SET file_name = ?, file_path = ? WHERE id = ?", nextName, nextPath.toString(), id);
        return get(id);
    }

    public void updatePaths(Long programId, Path oldRoot, Path newRoot) {
        jdbc.update("UPDATE documents SET file_path = REPLACE(file_path, ?, ?) WHERE program_id = ?",
                oldRoot.toString(), newRoot.toString(), programId);
    }

    private StoredDocument findStored(Long id) {
        return jdbc.query(selectSql() + " WHERE d.id = ?", this::map, id).stream().findFirst()
                .orElseThrow(() -> new ResourceNotFoundException("Document not found: " + id));
    }

    private String selectSql() {
        return "SELECT d.id, d.program_id, d.file_name, d.file_path, d.file_type, d.uploaded_at FROM documents d";
    }

    private Path programDocumentsFolder(Long programId, String folderName) {
        String programFolderName = jdbc.queryForObject(
            "SELECT CONCAT(program_code, '_', program_name, '_', batch_number) FROM programs WHERE id = ?",
                String.class, programId);
        Path root = Path.of("program-folders", programFolderName.replaceAll("[^A-Za-z0-9._-]+", "_"));
        if (folderName == null || folderName.isBlank()) throw new IllegalArgumentException("Select a folder before uploading");
        String target = safeFolderPath(folderName);
        Path folder = safeRelativePath(root, target);
        if (!folder.startsWith(root)) throw new IllegalArgumentException("Invalid folder name");
        return folder;
    }

    private Path safeRelativePath(Path root, String value) {
        Path relative = Path.of(value.replace('\\', '/')).normalize();
        Path resolved = root.resolve(relative).normalize();
        if (!resolved.startsWith(root)) throw new IllegalArgumentException("Invalid folder path");
        return resolved;
    }

    private String safeFolderPath(String value) {
        return String.join("/", value.trim().replace('\\', '/').split("/")).replaceAll("[^A-Za-z0-9._ /-]+", "_");
    }

    private StoredDocument map(java.sql.ResultSet result, int rowNumber) throws java.sql.SQLException {
        Path path = Path.of(result.getString("file_path"));
        long size;
        try {
            size = Files.exists(path) ? Files.size(path) : 0;
        } catch (IOException exception) {
            size = 0;
        }
        return new StoredDocument(result.getLong("id"), result.getLong("program_id"), result.getString("file_name"),
            result.getString("file_type"), size, result.getTimestamp("uploaded_at").toInstant(), path.toString());
    }

    private String safeFilename(String filename) {
        String value = filename == null || filename.isBlank() ? "document" : filename;
        return Path.of(value).getFileName().toString().replaceAll("[^A-Za-z0-9._-]", "_");
    }

    private record StoredDocument(Long id, Long programId, String filename, String contentType, long size,
                                  java.time.Instant uploadedAt, String path) {
        DocumentResponse response() {
            return new DocumentResponse(id, programId, filename, contentType, size, uploadedAt, Path.of(path).getParent().getFileName().toString());
        }
    }
}
