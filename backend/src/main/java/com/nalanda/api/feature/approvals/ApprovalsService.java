package com.nalanda.api.feature.approvals;

import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;

import org.springframework.stereotype.Service;

import com.nalanda.api.common.ResourceNotFoundException;

@Service
public class ApprovalsService {

    private final AtomicLong nextId = new AtomicLong(1);
    private final Map<Long, ApprovalResponse> approvals = new ConcurrentHashMap<>();

    public ApprovalsService() {
        createPending(101L, "Quality Excellence Program");
        createPending(102L, "Leadership Development Workshop");
    }

    public ApprovalListResponse list() {
        List<ApprovalResponse> items = approvals.values().stream()
                .sorted((left, right) -> left.id().compareTo(right.id()))
                .toList();
        return new ApprovalListResponse(items, items.size());
    }

    public ApprovalListResponse pending() {
        List<ApprovalResponse> items = approvals.values().stream()
                .filter(approval -> "PENDING".equalsIgnoreCase(approval.status()))
                .sorted((left, right) -> left.id().compareTo(right.id()))
                .toList();
        return new ApprovalListResponse(items, items.size());
    }

    public ApprovalResponse createPending(Long programId, String programName) {
        Long id = nextId.getAndIncrement();
        ApprovalResponse approval = new ApprovalResponse(id, programId, programName, "PENDING", null, null, null);
        approvals.put(id, approval);
        return approval;
    }

    public ApprovalResponse approve(Long id, String reviewedBy) {
        ApprovalResponse current = get(id);
        ApprovalResponse updated = new ApprovalResponse(current.id(), current.programId(), current.programName(),
                "APPROVED", "Approved by admin", reviewedBy, Instant.now());
        approvals.put(id, updated);
        return updated;
    }

    public ApprovalResponse reject(Long id, String reviewedBy, String reason) {
        ApprovalResponse current = get(id);
        String rejectedReason = reason == null || reason.isBlank() ? "Rejected by admin" : reason;
        ApprovalResponse updated = new ApprovalResponse(current.id(), current.programId(), current.programName(),
                "REJECTED", rejectedReason, reviewedBy, Instant.now());
        approvals.put(id, updated);
        return updated;
    }

    public ApprovalResponse get(Long id) {
        ApprovalResponse approval = approvals.get(id);
        if (approval == null) {
            throw new ResourceNotFoundException("Approval not found: " + id);
        }
        return approval;
    }
}
