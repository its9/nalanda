package com.nalanda.api.feature.wings;

import jakarta.validation.constraints.NotBlank;

import java.util.List;

record WingRequest(
        @NotBlank String code,
        @NotBlank String name,
        String description) {
}

record WingResponse(Long id, String code, String name, String description) {
}

record WingListResponse(List<WingResponse> items, long total) {
}