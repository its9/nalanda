package com.nalanda.api.feature.permissions;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/permissions")
public class PermissionsController {

    private final PermissionsService service;

    public PermissionsController(PermissionsService service) {
        this.service = service;
    }

    @GetMapping
    public PermissionListResponse list() {
        return service.list();
    }

}