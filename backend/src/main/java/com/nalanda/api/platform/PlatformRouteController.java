package com.nalanda.api.platform;

import java.time.Instant;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping
public class PlatformRouteController {

    @GetMapping({"", "/"})
    public Map<String, Object> root() {
        return Map.of(
                "name", "Nalanda Backend API",
                "status", "OK",
                "docs", "/api/docs",
                "swagger", "/api/swagger-ui.html");
    }

        @GetMapping({
            "/audit/{id}"})
    public PlatformResponse get(@PathVariable Long id) {
        return response("get", id);
    }

    @PostMapping({})
    public PlatformResponse create(@RequestBody(required = false) Map<String, Object> body) {
        return response("created", null);
    }

        @PutMapping({
            })
    public PlatformResponse update(@PathVariable Long id,
                                   @RequestBody(required = false) Map<String, Object> body) {
        return response("updated", id);
    }

        @DeleteMapping({
            })
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        return ResponseEntity.noContent().build();
    }

    @GetMapping({"/audit/user/{userId}", "/audit/program/{programId}"})
    public PlatformResponse lookup(@PathVariable(required = false) Long id) {
        return response("lookup", id);
    }

    @GetMapping({"/calendar", "/calendar/programs", "/calendar/halls", "/calendar/faculty"})
    public PlatformCollection calendar() {
        return new PlatformCollection(List.of(), 0);
    }

    @GetMapping("/audit/date-range")
    public PlatformCollection auditDateRange(@RequestParam String start, @RequestParam String end) {
        return new PlatformCollection(List.of(), 0);
    }

    private PlatformResponse response(String message, Long id) {
        return new PlatformResponse(message, id, Instant.now());
    }

    public record PlatformResponse(String message, Long id, Instant timestamp) {
    }

    public record PlatformCollection(List<Object> items, long total) {
    }

    public record FeedbackSummary(Long programId, int responses, double contentRating, double facultyRating,
                                  double facilityRating, double overallRating) {
    }

    public record PermissionResponse(Long roleId, List<String> permissions) {
    }
}