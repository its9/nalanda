package com.nalanda.api.feature.notifications;

import java.time.Instant;
import java.util.List;

import jakarta.validation.constraints.NotBlank;

record NotificationRequest(@NotBlank String type, @NotBlank String title, @NotBlank String message,
                           Long userId, String relatedId) {
}

record NotificationResponse(Long id, String type, String title, String message,
                             Long userId, String relatedId, boolean read, Instant createdAt) {
}

record NotificationListResponse(List<NotificationResponse> items, long total, long unread) {
}