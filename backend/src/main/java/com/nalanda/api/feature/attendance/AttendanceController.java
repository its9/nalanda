package com.nalanda.api.feature.attendance;

import java.util.List;
import java.time.LocalDate;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/attendance")
public class AttendanceController {

    private final AttendanceService service;

    public AttendanceController(AttendanceService service) {
        this.service = service;
    }

    @GetMapping
    public AttendanceListResponse list(@RequestParam(required = false) Long programId) {
        return programId == null ? service.list() : service.byProgram(programId);
    }

    @GetMapping("/{id}")
    public AttendanceResponse get(@PathVariable Long id) {
        return service.get(id);
    }

    @PostMapping
    public ResponseEntity<AttendanceResponse> create(@Valid @RequestBody AttendanceRequest request) {
        return ResponseEntity.status(201).body(service.create(request));
    }

    @PutMapping("/{id}")
    public AttendanceResponse update(@PathVariable Long id, @Valid @RequestBody AttendanceRequest request) {
        return service.update(id, request);
    }

    @PostMapping("/mark")
    public AttendanceResponse mark(@Valid @RequestBody AttendanceRequest request) {
        return service.create(request);
    }

    @PostMapping("/bulk")
    public AttendanceListResponse bulk(@Valid @RequestBody List<AttendanceRequest> requests) {
        return service.bulk(requests);
    }

    @GetMapping("/summary/{programId}")
    public AttendanceSummary summary(@PathVariable Long programId) {
        return service.summary(programId);
    }

    @GetMapping("/percentage/{programId}")
    public double percentage(@PathVariable Long programId) {
        return service.summary(programId).attendancePercentage();
    }

    @GetMapping("/employee")
    public AttendanceListResponse nominatedEmployee(@RequestParam String employeeNumber) {
        return service.nominatedEmployee(employeeNumber);
    }

    @GetMapping("/program/{programId}/nominated")
    public AttendanceListResponse nominatedProgram(@PathVariable Long programId,
                                                   @RequestParam(required = false) LocalDate date) {
        return service.nominatedProgram(programId, date);
    }
}