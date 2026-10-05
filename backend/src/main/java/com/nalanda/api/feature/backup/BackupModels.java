package com.nalanda.api.feature.backup;

import java.time.Instant;
import java.util.List;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

record BackupSettingsRequest(@NotBlank String backupPath, @NotNull Boolean automaticBackup,
                             @NotBlank String frequency, @NotBlank String time, int retentionDays) {
}

record BackupSettingsResponse(String backupPath, boolean automaticBackup, String frequency,
                              String time, int retentionDays) {
}

record BackupResponse(Long id, String backupPath, String status, Instant createdAt, long sizeBytes) {
}

record BackupListResponse(List<BackupResponse> items, long total) {
}

record BackupActionResponse(Long backupId, String action, String status, Instant timestamp) {
}