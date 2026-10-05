package com.nalanda.api.feature.documents;

import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/documents")
public class DocumentsController {

    private final DocumentsService service;

    public DocumentsController(DocumentsService service) {
        this.service = service;
    }

    @GetMapping
    public DocumentListResponse list() {
        return service.list();
    }

    @PostMapping("/upload")
    public ResponseEntity<DocumentResponse> upload(@RequestPart("file") MultipartFile file,
                                                    @RequestParam(required = false) Long programId,
                                                    @RequestParam(required = false) String folder) {
        return ResponseEntity.status(201).body(service.upload(file, programId, folder));
    }

    @GetMapping("/{id}")
    public DocumentResponse get(@PathVariable Long id) {
        return service.get(id);
    }

    @GetMapping("/{id}/download")
        public ResponseEntity<ByteArrayResource> download(@PathVariable Long id,
                                   @RequestParam(defaultValue = "false") boolean inline) {
        DocumentDownload document = service.download(id);
        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(document.contentType() == null
                        ? MediaType.APPLICATION_OCTET_STREAM_VALUE : document.contentType()))
            .header(HttpHeaders.CONTENT_DISPOSITION, (inline ? "inline" : "attachment") + "; filename=" + document.filename())
                .body(new ByteArrayResource(document.content()));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }

    @PatchMapping("/{id}")
    public ResponseEntity<DocumentResponse> rename(@PathVariable Long id, @RequestBody DocumentRenameRequest request) {
        return ResponseEntity.ok(service.rename(id, request.filename()));
    }
}