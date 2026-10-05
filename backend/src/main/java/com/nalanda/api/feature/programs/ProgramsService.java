package com.nalanda.api.feature.programs;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import com.nalanda.api.common.ResourceNotFoundException;
import com.nalanda.api.feature.attendance.AttendanceListResponse;
import com.nalanda.api.feature.attendance.AttendanceService;
import com.nalanda.api.feature.documents.DocumentListResponse;
import com.nalanda.api.feature.documents.DocumentsService;
import com.nalanda.api.feature.feedback.FeedbackListResponse;
import com.nalanda.api.feature.feedback.FeedbackService;
import com.nalanda.api.feature.nominations.NominationsService;

@Service
public class ProgramsService {

    private final ProgramsRepository repository;
    private final AttendanceService attendanceService;
    private final NominationsService nominationsService;
    private final DocumentsService documentsService;
    private final FeedbackService feedbackService;
    private final JdbcTemplate jdbc;

    public ProgramsService(ProgramsRepository repository, AttendanceService attendanceService, NominationsService nominationsService,
                           DocumentsService documentsService, FeedbackService feedbackService, JdbcTemplate jdbc) {
        this.repository = repository;
        this.attendanceService = attendanceService;
        this.nominationsService = nominationsService;
        this.documentsService = documentsService;
        this.feedbackService = feedbackService;
        this.jdbc = jdbc;
    }

    public ProgramListResponse list(String unit, String type, String status, Integer year, Integer month) {
        List<ProgramResponse> items = repository.list(unit, type, status, year, month);
        return new ProgramListResponse(items, items.size());
    }

    public ProgramResponse get(Long id) {
        return repository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Program not found: " + id));
    }

    public Map<String, Object> reportData(Long id) {
        ProgramResponse program = get(id);
        ProgramCalculationResponse calculation = calculations(id);
        return Map.of("id", program.id(), "code", program.code(), "name", program.name(),
                "status", program.status(), "unit", program.unit(), "nominated", calculation.nominated(),
                "present", calculation.present(), "absent", calculation.absent(),
                "mandays", calculation.mandays(), "trainingHours", calculation.trainingHours());
    }

    public long reportCount() {
        return repository.list(null, null, null, null, null).size();
    }

    public ProgramResponse create(ProgramRequest request) {
        ProgramResponse program = repository.create(request);
        createFolder(program.id(), false);
        return program;
    }

    public ProgramResponse update(Long id, ProgramRequest request) {
        ProgramResponse previous = get(id);
        ProgramResponse updated = repository.update(id, request);
        renameFolder(previous, updated);
        return updated;
    }

    public void delete(Long id) {
        if (repository.delete(id) == 0) {
            throw new ResourceNotFoundException("Program not found: " + id);
        }
    }

    public ProgramListResponse search(String name) {
        List<ProgramResponse> items = repository.search(name);
        return new ProgramListResponse(items, items.size());
    }

    public ProgramResponse lifecycle(Long id, String status) {
        return repository.updateStatus(id, status);
    }

    public ProgramRelatedResponse related(Long id) {
        get(id);
        return new ProgramRelatedResponse(List.of(), 0);
    }

    public AttendanceListResponse attendance(Long id) {
        get(id);
        return attendanceService.byProgram(id);
    }

    public DocumentListResponse documents(Long id) {
        get(id);
        return documentsService.byProgram(id);
    }

    public FeedbackListResponse feedback(Long id) {
        get(id);
        return feedbackService.byProgram(String.valueOf(id));
    }

    public ProgramFolderResponse createFolder(Long id, boolean recreate) {
        ProgramResponse program = get(id);
        Path root = programFolder(program);
        try {
            if (recreate && Files.exists(root)) {
                try (var paths = Files.walk(root)) {
                    paths.sorted(java.util.Comparator.reverseOrder()).forEach(path -> {
                        try {
                            Files.delete(path);
                        } catch (IOException exception) {
                            throw new IllegalStateException("Could not recreate program folder", exception);
                        }
                    });
                }
            }
            Files.createDirectories(root);
            List<String> folders;
            try (var paths = Files.list(root)) {
                folders = paths.filter(Files::isDirectory).map(path -> path.getFileName().toString()).sorted().toList();
            }
            return new ProgramFolderResponse(id, root.toAbsolutePath().toString(), folders, true);
        } catch (IOException exception) {
            throw new IllegalStateException("Could not create program folder", exception);
        }
    }

    public ProgramFolderResponse folder(Long id) {
        return createFolder(id, false);
    }

    public Map<String, Object> createSubfolder(Long id, String name, String parent) {
        ProgramResponse program = get(id);
        String folderName = name == null ? "" : name.trim().replaceAll("[^A-Za-z0-9._ -]+", "_");
        if (folderName.isBlank() || folderName.equals(".") || folderName.equals("..")) {
            throw new IllegalArgumentException("A valid folder name is required");
        }
        Path root = programFolder(program);
        Path parentPath = safeRelativePath(root, parent);
        Path folder = parentPath.resolve(folderName).normalize();
        if (!folder.startsWith(root)) throw new IllegalArgumentException("Invalid folder name");
        try {
            Files.createDirectories(root);
            Files.createDirectory(folder);
            return Map.of("programId", id, "name", folderName, "path", folder.toAbsolutePath().toString());
        } catch (java.nio.file.FileAlreadyExistsException exception) {
            throw new IllegalArgumentException("A folder with this name already exists");
        } catch (IOException exception) {
            throw new IllegalStateException("Could not create program subfolder", exception);
        }
    }

    public List<String> listSubfolders(Long id) {
        ProgramResponse program = get(id);
        Path root = programFolder(program);
        try {
            if (!Files.exists(root)) return List.of();
            try (var paths = Files.walk(root)) {
                return paths.filter(Files::isDirectory).filter(path -> !path.equals(root))
                        .map(path -> root.relativize(path).toString().replace(java.io.File.separatorChar, '/')).sorted().toList();
            }
        } catch (IOException exception) {
            throw new IllegalStateException("Could not list program folders", exception);
        }
    }

    public void deleteSubfolder(Long id, String path) {
        ProgramResponse program = get(id);
        Path root = programFolder(program);
        Path target = safeRelativePath(root, path);
        if (target.equals(root) || !target.startsWith(root) || !Files.exists(target) || !Files.isDirectory(target)) {
            throw new IllegalArgumentException("Folder not found");
        }

        String prefix = target.toString().replace('\\', '/');
        jdbc.update("DELETE FROM documents WHERE program_id = ? AND (file_path = ? OR file_path LIKE ?)",
                id, prefix, prefix + "/%")
                ;

        try (var paths = Files.walk(target)) {
            paths.sorted(Comparator.reverseOrder()).forEach(current -> {
                try {
                    Files.deleteIfExists(current);
                } catch (IOException exception) {
                    throw new IllegalStateException("Could not delete program folder", exception);
                }
            });
        } catch (IOException exception) {
            throw new IllegalStateException("Could not delete program folder", exception);
        }
    }

    private void renameFolder(ProgramResponse previous, ProgramResponse updated) {
        Path oldRoot = programFolder(previous);
        if (!Files.exists(oldRoot)) oldRoot = legacyProgramFolder(previous);
        Path newRoot = programFolder(updated);
        if (oldRoot.equals(newRoot) || !Files.exists(oldRoot)) return;
        try {
            if (Files.exists(newRoot)) {
                throw new IllegalStateException("Program folder already exists: " + newRoot);
            }
            Files.move(oldRoot, newRoot);
            documentsService.updatePaths(updated.id(), oldRoot, newRoot);
        } catch (IOException exception) {
            throw new IllegalStateException("Could not rename program folder", exception);
        }
    }

    private Path programFolder(ProgramResponse program) {
        String folderName = program.code() + "_" + program.name() + "_" + program.batchNumber();
        return Path.of("program-folders", folderName.replaceAll("[^A-Za-z0-9._-]+", "_"));
    }

    private Path safeRelativePath(Path root, String value) {
        if (value == null || value.isBlank()) return root;
        Path relative = Path.of(value.replace('\\', '/')).normalize();
        Path resolved = root.resolve(relative).normalize();
        if (!resolved.startsWith(root)) throw new IllegalArgumentException("Invalid folder path");
        return resolved;
    }

    private Path legacyProgramFolder(ProgramResponse program) {
        String folderName = program.code() + "_" + program.name();
        return Path.of("program-folders", folderName.replaceAll("[^A-Za-z0-9._-]+", "_"));
    }

    public List<String> files(Long id) {
        ProgramFolderResponse folder = folder(id);
        return folder.folders();
    }

    public ProgramCalculationResponse calculations(Long id) {
        ProgramResponse program = get(id);
        var attendance = attendanceService.summary(id);
        int nominated = nominationsService.countByProgram(id);
        int present = attendance.present();
        int absent = Math.max(nominated - present, 0);
        double percentage = nominated == 0 ? 0 : Math.round(present * 1000.0 / nominated) / 10.0;
        return new ProgramCalculationResponse(program.programDays(), program.hoursPerDay(), nominated, present,
                absent, percentage, present * program.programDays(),
                present * program.programDays() * program.hoursPerDay());
    }

}