package com.nalanda.api.feature.nominations;

import java.util.List;

import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/nominations")
public class NominationsController {

    private final NominationsService service;

    public NominationsController(NominationsService service) {
        this.service = service;
    }

    @GetMapping
    public NominationListResponse list() {
        return service.list();
    }

    @GetMapping("/{id}")
    public NominationResponse get(@PathVariable Long id) {
        return service.get(id);
    }

    @PostMapping
    public ResponseEntity<NominationResponse> create(@Valid @RequestBody NominationRequest request) {
        return ResponseEntity.status(201).body(service.create(request));
    }

    @PutMapping("/{id}")
    public NominationResponse update(@PathVariable Long id, @Valid @RequestBody NominationRequest request) {
        return service.update(id, request);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/{id}/approve")
    public NominationResponse approve(@PathVariable Long id) {
        return service.decide(id, "APPROVED");
    }

    @PutMapping("/{id}/cancel")
    public NominationResponse cancel(@PathVariable Long id) {
        return service.decide(id, "CANCELLED");
    }

    @PostMapping("/bulk")
    public NominationBulkResponse bulk(@Valid @RequestBody List<NominationRequest> requests) {
        return service.bulk(requests);
    }

    @PostMapping("/import")
    public NominationBulkResponse importNominations(@RequestPart("file") MultipartFile file,
                                                    @RequestParam Long programId) {
        return service.importFile(file, programId);
    }

    @GetMapping("/export")
    public ResponseEntity<ByteArrayResource> export() {
        return download(service.export(), "nominations.csv");
    }

    @GetMapping("/template")
    public ResponseEntity<ByteArrayResource> template() {
        return download(service.template(), "nominations-template.csv");
    }

    private ResponseEntity<ByteArrayResource> download(byte[] content, String filename) {
        return ResponseEntity.ok().contentType(MediaType.parseMediaType("text/csv"))
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + filename)
                .body(new ByteArrayResource(content));
    }
}