package com.nalanda.api.feature.programs;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.nalanda.api.feature.attendance.AttendanceListResponse;
import com.nalanda.api.feature.documents.DocumentListResponse;
import com.nalanda.api.feature.feedback.FeedbackListResponse;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/programs")
public class ProgramsController {

    private final ProgramsService service;

    public ProgramsController(ProgramsService service) {
        this.service = service;
    }

    @GetMapping
    public ProgramListResponse list(@RequestParam(required = false) String unit,
                                    @RequestParam(required = false) String type,
                                    @RequestParam(required = false) String status,
                                    @RequestParam(required = false) Integer year,
                                    @RequestParam(required = false) Integer month) {
        return service.list(unit, type, status, year, month);
    }

    @GetMapping("/{id}")
    public ProgramResponse get(@PathVariable Long id) {
        return service.get(id);
    }

    @PostMapping
    public ResponseEntity<ProgramResponse> create(@Valid @RequestBody ProgramRequest request) {
        return ResponseEntity.status(201).body(service.create(request));
    }

    @PutMapping("/{id}")
    public ProgramResponse update(@PathVariable Long id, @Valid @RequestBody ProgramRequest request) {
        return service.update(id, request);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/search")
    public ProgramListResponse search(@RequestParam(required = false) String name) {
        return service.search(name);
    }

    @GetMapping("/{id}/participants")
    public ProgramRelatedResponse participants(@PathVariable Long id) {
        return service.related(id);
    }

    @GetMapping("/{id}/nominations")
    public ProgramRelatedResponse nominations(@PathVariable Long id) {
        return service.related(id);
    }

    @GetMapping("/{id}/attendance")
    public AttendanceListResponse attendance(@PathVariable Long id) {
        return service.attendance(id);
    }

    @GetMapping("/{id}/faculty")
    public ProgramRelatedResponse faculty(@PathVariable Long id) {
        return service.related(id);
    }

    @GetMapping("/{id}/documents")
    public DocumentListResponse documents(@PathVariable Long id) {
        return service.documents(id);
    }

    @GetMapping("/{id}/feedback")
    public FeedbackListResponse feedback(@PathVariable Long id) {
        return service.feedback(id);
    }

    @GetMapping("/{id}/report")
    public ProgramRelatedResponse report(@PathVariable Long id) {
        return service.related(id);
    }

    @PutMapping("/{id}/start")
    public ProgramResponse start(@PathVariable Long id) {
        return service.lifecycle(id, "ONGOING");
    }

    @PutMapping("/{id}/complete")
    public ProgramResponse complete(@PathVariable Long id) {
        return service.lifecycle(id, "COMPLETED");
    }

    @PutMapping("/{id}/cancel")
    public ProgramResponse cancel(@PathVariable Long id) {
        return service.lifecycle(id, "CANCELLED");
    }

    @PutMapping("/{id}/postpone")
    public ProgramResponse postpone(@PathVariable Long id) {
        return service.lifecycle(id, "POSTPONED");
    }

    @PostMapping("/{id}/folder")
    public ProgramFolderResponse createFolder(@PathVariable Long id) {
        return service.createFolder(id, false);
    }

    @PostMapping("/{id}/folders")
    public java.util.Map<String, Object> createSubfolder(@PathVariable Long id,
                                                         @RequestParam String name,
                                                         @RequestParam(required = false) String parent) {
        return service.createSubfolder(id, name, parent);
    }

    @GetMapping("/{id}/folders")
    public List<String> listSubfolders(@PathVariable Long id) {
        return service.listSubfolders(id);
    }

    @DeleteMapping("/{id}/folders")
    public ResponseEntity<Void> deleteSubfolder(@PathVariable Long id, @RequestParam String path) {
        service.deleteSubfolder(id, path);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}/folder")
    public ProgramFolderResponse folder(@PathVariable Long id) {
        return service.folder(id);
    }

    @PostMapping("/{id}/folder/recreate")
    public ProgramFolderResponse recreateFolder(@PathVariable Long id) {
        return service.createFolder(id, true);
    }

    @GetMapping("/{id}/files")
    public List<String> files(@PathVariable Long id) {
        return service.files(id);
    }

    @GetMapping("/{id}/calculations")
    public ProgramCalculationResponse calculations(@PathVariable Long id) {
        return service.calculations(id);
    }
}