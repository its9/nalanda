package com.nalanda.api.feature.excel;

import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
public class ExcelController {

    private final ExcelService service;

    public ExcelController(ExcelService service) {
        this.service = service;
    }

    @PostMapping("/import/employees")
    public ExcelImportResponse importEmployees(@RequestPart("file") MultipartFile file) {
        return service.importData("employees", file);
    }

    @PostMapping("/import/programs")
    public ExcelImportResponse importPrograms(@RequestPart("file") MultipartFile file) {
        return service.importData("programs", file);
    }

    @PostMapping("/import/nominations")
    public ExcelImportResponse importNominations(@RequestPart("file") MultipartFile file) {
        return service.importData("nominations", file);
    }

    @PostMapping("/import/attendance")
    public ExcelImportResponse importAttendance(@RequestPart("file") MultipartFile file) {
        return service.importData("attendance", file);
    }

    @GetMapping("/templates/employees")
    public ResponseEntity<ByteArrayResource> employeesTemplate() {
        return download(service.template("employees"), "employees-template.csv");
    }

    @GetMapping("/templates/programs")
    public ResponseEntity<ByteArrayResource> programsTemplate() {
        return download(service.template("programs"), "programs-template.csv");
    }

    @GetMapping("/templates/nominations")
    public ResponseEntity<ByteArrayResource> nominationsTemplate() {
        return download(service.template("nominations"), "nominations-template.csv");
    }

    @GetMapping("/templates/attendance")
    public ResponseEntity<ByteArrayResource> attendanceTemplate() {
        return download(service.template("attendance"), "attendance-template.csv");
    }

    @GetMapping("/export/employees")
    public ResponseEntity<ByteArrayResource> exportEmployees() {
        return download(service.export("employees"), "employees.csv");
    }

    @GetMapping("/export/programs")
    public ResponseEntity<ByteArrayResource> exportPrograms() {
        return download(service.export("programs"), "programs.csv");
    }

    @GetMapping("/export/nominations")
    public ResponseEntity<ByteArrayResource> exportNominations() {
        return download(service.export("nominations"), "nominations.csv");
    }

    @GetMapping("/export/attendance")
    public ResponseEntity<ByteArrayResource> exportAttendance() {
        return download(service.export("attendance"), "attendance.csv");
    }

    @GetMapping("/export/reports")
    public ResponseEntity<ByteArrayResource> exportReports() {
        return download(service.export("reports"), "reports.csv");
    }

    private ResponseEntity<ByteArrayResource> download(byte[] content, String filename) {
        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType("text/csv"))
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + filename)
                .body(new ByteArrayResource(content));
    }
}
