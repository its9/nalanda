package com.nalanda.api.feature.feedback;

import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;

import java.time.LocalDate;
import java.util.List;

record FeedbackRequest(
        @NotBlank String programId,
        String employeeId,
        Integer rating,
        @DecimalMin("1.0") @DecimalMax("5.0") double contentRating,
        @DecimalMin("1.0") @DecimalMax("5.0") double facultyRating,
        @DecimalMin("1.0") @DecimalMax("5.0") double facilityRating,
        String comments,
        String status,
        LocalDate feedbackDate) {
}

record FeedbackResponse(Long id, String programId, String programName, String employeeName, String department,
                        String type, Integer rating, String comments, String status, LocalDate feedbackDate,
                        double contentRating, double facultyRating, double facilityRating, double overallRating) {
}
