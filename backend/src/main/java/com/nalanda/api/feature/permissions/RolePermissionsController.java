package com.nalanda.api.feature.permissions;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/roles")
public class RolePermissionsController {

    private final PermissionsService service;

    public RolePermissionsController(PermissionsService service) {
        this.service = service;
    }

    @GetMapping("/{roleId}/permissions")
    public PermissionResponse get(@PathVariable Long roleId) {
        return service.get(roleId);
    }

    @PutMapping("/{roleId}/permissions")
    public PermissionResponse update(@PathVariable Long roleId,
                                     @Valid @RequestBody PermissionUpdateRequest request) {
        return service.update(roleId, request);
    }
}