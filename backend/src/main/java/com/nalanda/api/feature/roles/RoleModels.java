package com.nalanda.api.feature.roles;

import jakarta.validation.constraints.NotBlank;

import java.util.List;

record RoleRequest(@NotBlank String code, @NotBlank String name, String description) {
}

record RoleResponse(Long id, String code, String name, String description) {
}

record RoleListResponse(List<RoleResponse> items, long total) {
}