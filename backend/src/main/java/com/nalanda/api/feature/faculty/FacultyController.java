package com.nalanda.api.feature.faculty;

import org.springframework.http.ResponseEntity;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.multipart.MultipartFile;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/faculty")
public class FacultyController {

    private final FacultyService service;

    public FacultyController(FacultyService service) {
        this.service = service;
    }

    @GetMapping
    public FacultyListResponse list() {
        return service.list();
    }

    @GetMapping("/{id}")
    public FacultyResponse get(@PathVariable Long id) {
        return service.get(id);
    }

    @PostMapping
    public ResponseEntity<FacultyResponse> create(@Valid @RequestBody FacultyRequest request) {
        return ResponseEntity.status(201).body(service.create(request));
    }

    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<FacultyResponse> createWithPhoto(
            @RequestParam String name,
            @RequestParam(required = false) String email,
            @RequestParam String organization,
            @RequestParam String specialization,
            @RequestParam String type,
            @RequestParam String status,
            @RequestPart(required = false) MultipartFile photo) throws java.io.IOException {
        return ResponseEntity.status(201).body(service.create(
                new FacultyRequest(name, email, organization, specialization, type, status),
                photo == null || photo.isEmpty() ? null : photo.getBytes(),
                photo == null ? null : photo.getContentType()));
    }

    @PutMapping("/{id}")
    public FacultyResponse update(@PathVariable Long id, @Valid @RequestBody FacultyRequest request) {
        return service.update(id, request);
    }

    @PutMapping(value = "/{id}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public FacultyResponse updateWithPhoto(
            @PathVariable Long id,
            @RequestParam String name,
            @RequestParam(required = false) String email,
            @RequestParam String organization,
            @RequestParam String specialization,
            @RequestParam String type,
            @RequestParam String status,
            @RequestPart(required = false) MultipartFile photo) throws java.io.IOException {
        return service.update(id, new FacultyRequest(name, email, organization, specialization, type, status),
                photo == null || photo.isEmpty() ? null : photo.getBytes(),
                photo == null ? null : photo.getContentType());
    }

    @GetMapping("/{id}/photo")
    public ResponseEntity<byte[]> photo(@PathVariable Long id) {
        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(service.photoContentType(id)))
                .body(service.photo(id));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{id}/programs")
    public FacultyRelatedResponse programs(@PathVariable Long id) {
        return service.programs(id);
    }

    @GetMapping("/{id}/history")
    public FacultyRelatedResponse history(@PathVariable Long id) {
        return service.history(id);
    }

    @GetMapping("/{id}/statistics")
    public FacultyStatistics statistics(@PathVariable Long id) {
        return service.statistics(id);
    }
}