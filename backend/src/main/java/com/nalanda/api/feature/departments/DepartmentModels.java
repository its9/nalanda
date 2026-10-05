package com.nalanda.api.feature.departments;

import jakarta.validation.constraints.NotBlank;

import java.util.List;

record DepartmentRequest(
        @NotBlank String code,
        @NotBlank String name,
        String description) {
}

record DepartmentResponse(
        Long id,
        String code,
        String name,
        String description) {
}

record DepartmentListResponse(List<DepartmentResponse> items, long total) {
}