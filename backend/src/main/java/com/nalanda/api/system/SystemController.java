package com.nalanda.api.system;

import java.time.Instant;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/system")
public class SystemController {

    @GetMapping("/health")
    public HealthResponse health() {
        return new HealthResponse("UP", "nalanda-backend-api", Instant.now());
    }

    public record HealthResponse(String status, String service, Instant timestamp) {
    }
}