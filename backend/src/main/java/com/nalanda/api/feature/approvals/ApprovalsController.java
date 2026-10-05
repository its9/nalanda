package com.nalanda.api.feature.approvals;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/approvals")
public class ApprovalsController {

    private final ApprovalsService service;

    public ApprovalsController(ApprovalsService service) {
        this.service = service;
    }

    @GetMapping
    public ApprovalListResponse list() {
        return service.list();
    }

    @GetMapping("/pending")
    public ApprovalListResponse pending() {
        return service.pending();
    }

    @PostMapping("/{id}/approve")
    public ApprovalResponse approve(@PathVariable Long id) {
        return service.approve(id, "admin");
    }

    @PostMapping("/{id}/reject")
    public ApprovalResponse reject(@PathVariable Long id, @RequestBody(required = false) ApprovalDecisionRequest request) {
        String reason = request == null ? null : request.reason();
        return service.reject(id, "admin", reason);
    }
}
