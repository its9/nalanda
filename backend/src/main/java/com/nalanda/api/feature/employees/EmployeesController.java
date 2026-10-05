package com.nalanda.api.feature.employees;

import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.nalanda.api.feature.attendance.AttendanceListResponse;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/employees")
public class EmployeesController {

    private final EmployeesService service;

    public EmployeesController(EmployeesService service) {
        this.service = service;
    }

    @GetMapping
    public EmployeeListResponse list(@RequestParam(required = false) String department,
                                     @RequestParam(required = false) String unit) {
        return service.list(department, unit);
    }

    @GetMapping("/{id}")
    public EmployeeResponse get(@PathVariable Long id) {
        return service.get(id);
    }

    @PostMapping
    public ResponseEntity<EmployeeResponse> create(@Valid @RequestBody EmployeeRequest request) {
        return ResponseEntity.status(201).body(service.create(request));
    }

    @PutMapping("/{id}")
    public EmployeeResponse update(@PathVariable Long id, @Valid @RequestBody EmployeeRequest request) {
        return service.update(id, request);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/search")
    public EmployeeListResponse search(@RequestParam(required = false) String name,
                                       @RequestParam(required = false) String employeeId) {
        return service.search(name, employeeId);
    }

    @GetMapping("/options")
    public EmployeeOptionsResponse options() {
        return service.options();
    }

    @GetMapping("/{id}/programs")
    public EmployeeListResponse programs(@PathVariable Long id) {
        return service.programs(id);
    }

    @GetMapping("/{id}/nominations")
    public EmployeeListResponse nominations(@PathVariable Long id) {
        return service.nominations(id);
    }

    @GetMapping("/{id}/attendance")
    public AttendanceListResponse attendance(@PathVariable Long id) {
        return service.attendanceRecords(id);
    }

    @GetMapping("/{id}/certificates")
    public EmployeeListResponse certificates(@PathVariable Long id) {
        return service.certificates(id);
    }

    @GetMapping("/{id}/training-history")
    public EmployeeListResponse trainingHistory(@PathVariable Long id) {
        return service.trainingHistory(id);
    }

    @PostMapping("/import")
    public EmployeeImportResponse importEmployees(@RequestPart("file") MultipartFile file) {
        return service.importFile(file);
    }

    @GetMapping("/export")
    public ResponseEntity<ByteArrayResource> export() {
        return download(service.export(), "employees.csv");
    }

    @GetMapping("/template")
    public ResponseEntity<ByteArrayResource> template() {
        return download(service.template(), "employees-template.csv");
    }

    private ResponseEntity<ByteArrayResource> download(byte[] content, String filename) {
        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType("text/csv"))
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + filename)
                .body(new ByteArrayResource(content));
    }
}