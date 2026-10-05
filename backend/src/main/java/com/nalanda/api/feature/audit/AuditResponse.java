package com.nalanda.api.feature.audit;

import java.time.Instant;

public record AuditResponse(Long id, Long userId, String user, String action, String program,
                            Instant dateTime, String ipAddress) {
}