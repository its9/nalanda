package com.nalanda.api.feature.attendance;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.time.LocalDate;
import java.util.List;

record AttendanceRequest(
        @NotNull Long programId,
        @NotNull Long employeeId,
        @NotNull LocalDate date,
        @NotBlank String status,
        String remarks) {
}

record AttendanceResponse(Long id, Long programId, Long employeeId, LocalDate date, String status,
                                 String programName, String employeeNumber, String employeeName,
                                 String wing, String hall, String gender, String remarks) {
}
