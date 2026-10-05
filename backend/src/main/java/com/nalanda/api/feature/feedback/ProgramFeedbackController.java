package com.nalanda.api.feature.feedback;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/programs")
public class ProgramFeedbackController {

    private final FeedbackService service;

    public ProgramFeedbackController(FeedbackService service) {
        this.service = service;
    }

    @GetMapping("/{programId}/feedback/summary")
    public FeedbackSummary summary(@PathVariable String programId) {
        return service.summary(programId);
    }
}