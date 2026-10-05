package com.nalanda.api.feature.backup;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/backup")
public class BackupController {

    private final BackupService service;

    public BackupController(BackupService service) {
        this.service = service;
    }

    @GetMapping
    public BackupListResponse list() {
        return service.history();
    }

    @GetMapping("/drives")
    public java.util.List<String> drives() {
        return service.drives();
    }

    @GetMapping("/settings")
    public BackupSettingsResponse settings() {
        return service.settings();
    }

    @PutMapping("/settings")
    public BackupSettingsResponse updateSettings(@Valid @RequestBody BackupSettingsRequest request) {
        return service.updateSettings(request);
    }

    @PostMapping("/test")
    public BackupActionResponse test() {
        return service.test();
    }

    @PostMapping("/create")
    public BackupResponse create() {
        return service.create();
    }

    @GetMapping("/history")
    public BackupListResponse history() {
        return service.history();
    }

    @GetMapping("/{id}")
    public BackupResponse get(@PathVariable Long id) {
        return service.get(id);
    }

    @PostMapping("/{id}/restore")
    public BackupActionResponse restore(@PathVariable Long id) {
        return service.restore(id);
    }

    @PostMapping("/{id}/verify")
    public BackupActionResponse verify(@PathVariable Long id) {
        return service.verify(id);
    }
}