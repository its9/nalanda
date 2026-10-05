package com.nalanda.api.feature.users;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

import java.util.List;

record UserRequest(@NotBlank String username, @Email String email, @NotBlank String name, @NotBlank String role,
                   Long employeeId) {
}

record UserResponse(Long id, String username, String email, String name, String role, boolean active) {
}

record UserListResponse(List<UserResponse> items, long total) {
}

record UserActionResponse(Long id, String message, boolean active, String role) {
}