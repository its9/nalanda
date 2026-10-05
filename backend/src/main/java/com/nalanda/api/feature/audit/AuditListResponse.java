package com.nalanda.api.feature.audit;

import java.util.List;

public record AuditListResponse(List<AuditResponse> items, long total) {
}