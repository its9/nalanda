package com.nalanda.api.feature.programs;

import java.time.LocalDate;
import java.util.List;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;

record ProgramRequest(
        @NotBlank String batchNumber,
        @NotBlank String code,
        @NotBlank String name,
        String coordinator,
        String unit,
        String hall,
        @NotBlank String type,
        @NotBlank String status,
        LocalDate startDate,
        LocalDate endDate,
        Integer programDays,
        @Positive Integer hoursPerDay) {
}

record ProgramResponse(
        Long id,
        String batchNumber,
        String code,
        String name,
        String coordinator,
        String unit,
        String hall,
        String type,
        String status,
        Integer year,
        Integer month,
        Integer programDays,
        Integer hoursPerDay,
        LocalDate startDate,
        LocalDate endDate) {
}

record ProgramListResponse(List<ProgramResponse> items, long total) {
}

record ProgramRelatedResponse(List<Object> items, long total) {
}

record ProgramFolderResponse(Long programId, String path, List<String> folders, boolean created) {
}

record ProgramCalculationResponse(int programDays, int hoursPerDay, int nominated, int present,
                                  int absent, double attendancePercentage, int mandays, int trainingHours) {
}