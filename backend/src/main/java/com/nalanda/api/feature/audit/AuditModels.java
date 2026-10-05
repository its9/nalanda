package com.nalanda.api.feature.audit;

import java.time.Instant;

record AuditEntry(Long id, Long userId, String user, String action, String program,
                  Instant dateTime, String ipAddress) {
}