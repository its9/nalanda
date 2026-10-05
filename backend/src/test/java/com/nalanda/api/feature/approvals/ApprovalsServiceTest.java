package com.nalanda.api.feature.approvals;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import org.junit.jupiter.api.Test;

class ApprovalsServiceTest {

    @Test
    void approveMarksProgramApprovalAsApproved() {
        ApprovalsService service = new ApprovalsService();

        ApprovalResponse approval = service.createPending(101L, "Quality Excellence Program");
        ApprovalResponse updated = service.approve(approval.id(), "admin@nalanda");

        assertEquals("APPROVED", updated.status());
        assertEquals("admin@nalanda", updated.reviewedBy());
        assertFalse(service.pending().items().isEmpty());
    }
}
