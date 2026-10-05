package com.nalanda.api.feature.users;

import org.springframework.http.ResponseEntity;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/users")
public class UsersController {

    private final UsersService service;

    public UsersController(UsersService service) {
        this.service = service;
    }

    @GetMapping
    public UserListResponse list() {
        return service.list();
    }

    @GetMapping("/export")
    public ResponseEntity<ByteArrayResource> export() {
        return ResponseEntity.ok()
            .contentType(MediaType.parseMediaType("text/csv"))
            .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=users.csv")
            .body(new ByteArrayResource(service.exportCsv()));
    }

    @GetMapping("/{id}")
    public UserResponse get(@PathVariable Long id) {
        return service.get(id);
    }

    @PostMapping
    public ResponseEntity<UserResponse> create(@Valid @RequestBody UserRequest request) {
        return ResponseEntity.status(201).body(service.create(request));
    }

    @PutMapping("/{id}")
    public UserResponse update(@PathVariable Long id, @Valid @RequestBody UserRequest request) {
        return service.update(id, request);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/{id}/activate")
    public UserActionResponse activate(@PathVariable Long id) {
        return service.activate(id, true);
    }

    @PutMapping("/{id}/deactivate")
    public UserActionResponse deactivate(@PathVariable Long id) {
        return service.activate(id, false);
    }

    @PutMapping("/{id}/reset-password")
    public UserActionResponse resetPassword(@PathVariable Long id) {
        return service.resetPassword(id);
    }

    @PutMapping("/{id}/role")
    public UserActionResponse role(@PathVariable Long id, @RequestBody java.util.Map<String, String> body) {
        return service.updateRole(id, body.getOrDefault("role", "VIEWER"));
    }
}