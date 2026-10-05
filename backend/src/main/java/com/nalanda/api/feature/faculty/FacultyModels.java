package com.nalanda.api.feature.faculty;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

import java.util.List;

record FacultyRequest(
        @NotBlank String name,
        @Email String email,
        @NotBlank String organization,
        @NotBlank String specialization,
        @NotBlank String type,
        @NotBlank String status) {
}

record FacultyResponse(Long id, String name, String email, String organization,
                       String specialization, String type, String status, String photoUrl) {
}

record FacultyListResponse(List<FacultyResponse> items, long total) {
}

record FacultyRelatedResponse(List<Object> items, long total) {
}

record FacultyStatistics(Long facultyId, int totalPrograms, int completedPrograms,
                         int totalTrainingHours, double averageRating) {
}