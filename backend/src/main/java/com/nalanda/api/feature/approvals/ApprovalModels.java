package com.nalanda.api.feature.approvals;

import java.time.Instant;
import java.util.List;

record ApprovalResponse(
        Long id,
        Long programId,
        String programName,
        String status,
        String reason,
        String reviewedBy,
        Instant reviewedAt) {
}

record ApprovalListResponse(List<ApprovalResponse> items, long total) {
}

record ApprovalDecisionRequest(String reason) {
}
