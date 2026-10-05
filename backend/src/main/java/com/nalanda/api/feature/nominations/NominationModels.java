package com.nalanda.api.feature.nominations;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.util.List;

record NominationRequest(
        @NotNull Long programId,
        @NotNull Long employeeId,
        @NotBlank String status,
        String remarks) {
}

record NominationResponse(
        Long id,
        Long programId,
        Long employeeId,
        String status,
        String remarks,
        String employeeNumber,
        String employeeName,
        String programName,
        java.time.LocalDate nominationDate) {
}

record NominationListResponse(List<NominationResponse> items, long total) {
}

record NominationBulkResponse(int created, String message) {
}