package com.nalanda.api.feature.reports;

import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/reports")
public class ReportsController {

    private final ReportsService service;

    public ReportsController(ReportsService service) {
        this.service = service;
    }

    @GetMapping
    public ReportResponse list() {
        return service.report("reports", null, null);
    }

    @GetMapping({"/programs", "/attendance", "/nominations", "/employees", "/faculty", "/halls",
            "/mandays", "/training-hours"})
    public ReportResponse report() {
        return service.report("summary", null, null);
    }

    @GetMapping("/monthly")
    public ReportResponse monthly(@RequestParam Integer year, @RequestParam Integer month) {
        return service.report("monthly", year, month);
    }

    @GetMapping("/yearly")
    public ReportResponse yearly(@RequestParam Integer year) {
        return service.report("yearly", year, null);
    }

    @GetMapping("/program/{programId}")
    public ReportResponse program(@PathVariable Long programId) {
        return service.program(programId);
    }

    @GetMapping({"/programs/export", "/attendance/export", "/monthly/export", "/yearly/export"})
    public ResponseEntity<ByteArrayResource> export(@RequestParam(required = false) Integer year,
                                                    @RequestParam(required = false) Integer month) {
        return ResponseEntity.ok().contentType(MediaType.parseMediaType("text/csv"))
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=report.csv")
                .body(new ByteArrayResource(service.export("report", year, month)));
    }
}