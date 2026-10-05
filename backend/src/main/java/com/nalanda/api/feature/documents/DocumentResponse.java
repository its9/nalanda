package com.nalanda.api.feature.documents;

import java.time.Instant;

public record DocumentResponse(Long id, Long programId, String filename, String contentType,
                               long size, Instant uploadedAt, String folder) {
}