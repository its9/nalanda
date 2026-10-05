package com.nalanda.api.feature.feedback;

public record FeedbackSummary(String programId, int responses, double contentRating,
                              double facultyRating, double facilityRating, double overallRating) {
}