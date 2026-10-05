package com.nalanda.api.feature.feedback;

import java.util.List;

public record FeedbackListResponse(List<FeedbackResponse> items, long total) {
}