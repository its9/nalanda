package com.nalanda.api.feature.employees;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.transaction.annotation.Transactional;

import com.nalanda.api.common.ResourceNotFoundException;
import com.nalanda.api.feature.attendance.AttendanceListResponse;
import com.nalanda.api.feature.attendance.AttendanceService;

@Service
public class EmployeesService {

    private final EmployeesRepository repository;
    private final AttendanceService attendanceService;

    public EmployeesService(EmployeesRepository repository, AttendanceService attendanceService) {
        this.repository = repository;
        this.attendanceService = attendanceService;
    }

    public EmployeeListResponse list(String department, String unit) {
        List<EmployeeResponse> items = repository.list(department, unit);
        return new EmployeeListResponse(items, items.size());
    }

    public long reportCount() {
        return list(null, null).total();
    }

    public EmployeeResponse get(Long id) {
        return repository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Employee not found: " + id));
    }

    public EmployeeResponse create(EmployeeRequest request) {
        return repository.create(request);
    }

    public EmployeeResponse update(Long id, EmployeeRequest request) {
        get(id);
        return repository.update(id, request);
    }

    @Transactional
    public void delete(Long id) {
        if (repository.delete(id) == 0) {
            throw new ResourceNotFoundException("Employee not found: " + id);
        }
    }

    public EmployeeListResponse search(String name, String employeeId) {
        List<EmployeeResponse> items = repository.search(name, employeeId);
        return new EmployeeListResponse(items, items.size());
    }

    public EmployeeOptionsResponse options() {
        return repository.options();
    }

    @Transactional
    public EmployeeImportResponse importFile(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            return new EmployeeImportResponse(0, "No employee file was uploaded");
        }
        int imported = 0;
        DataFormatter formatter = new DataFormatter();
        try (InputStream input = file.getInputStream(); Workbook workbook = WorkbookFactory.create(input)) {
            Sheet sheet = workbook.getSheetAt(0);
            int headerRowIndex = findHeaderRow(sheet, formatter);
            Map<String, Integer> columns = columns(sheet.getRow(headerRowIndex), formatter);
            requireColumns(columns, "employeeid", "name", "department", "unit");
            for (int rowIndex = headerRowIndex + 1; rowIndex <= sheet.getLastRowNum(); rowIndex++) {
                Row row = sheet.getRow(rowIndex);
                if (row == null || blank(row, formatter)) {
                    continue;
                }
                repository.create(new EmployeeRequest(
                        value(row, columns, "employeeid", formatter),
                        value(row, columns, "name", formatter),
                        value(row, columns, "department", formatter),
                        value(row, columns, "unit", formatter),
                        value(row, columns, "email", formatter),
                        value(row, columns, "phone", formatter),
                        value(row, columns, "internalphone", formatter),
                        value(row, columns, "designation", formatter),
                        null,
                        defaultStatus(value(row, columns, "status", formatter))));
                imported++;
            }
        } catch (IOException | RuntimeException error) {
            throw new IllegalArgumentException("Employee Excel import failed: " + error.getMessage(), error);
        }
        return new EmployeeImportResponse(imported, imported + " employees imported");
    }

    private int findHeaderRow(Sheet sheet, DataFormatter formatter) {
        int lastCandidate = Math.min(sheet.getLastRowNum(), 10);
        for (int rowIndex = 0; rowIndex <= lastCandidate; rowIndex++) {
            Map<String, Integer> candidate = columns(sheet.getRow(rowIndex), formatter);
            if (candidate.containsKey("employeeid") && candidate.containsKey("name")
                    && candidate.containsKey("department") && candidate.containsKey("unit")) {
                return rowIndex;
            }
        }
        return 0;
    }

    private Map<String, Integer> columns(Row header, DataFormatter formatter) {
        if (header == null) {
            throw new IllegalArgumentException("The Excel file has no header row");
        }
        Map<String, Integer> columns = new HashMap<>();
        for (int cellIndex = 0; cellIndex < header.getLastCellNum(); cellIndex++) {
            String name = formatter.formatCellValue(header.getCell(cellIndex));
            if (!name.isBlank()) {
                String normalized = normalize(name);
                columns.put(normalized, cellIndex);
                if (normalized.equals("employeenumber")) columns.putIfAbsent("employeeid", cellIndex);
                if (normalized.equals("employeename")) columns.putIfAbsent("name", cellIndex);
                if (normalized.equals("dept") || normalized.equals("deptcode") || normalized.equals("deptname")
                        || normalized.equals("departmentcode") || normalized.equals("departmentname")
                    || normalized.equals("departmentcodeorname") || normalized.contains("department")) {
                    columns.putIfAbsent("department", cellIndex);
                }
                if (normalized.equals("unitcode") || normalized.equals("unitname")
                    || normalized.equals("unitcodeorname") || normalized.contains("unit")) {
                    columns.putIfAbsent("unit", cellIndex);
                }
                if (normalized.equals("internalphonenumber") || normalized.equals("internalphone")) {
                    columns.putIfAbsent("internalphone", cellIndex);
                }
            }
        }
        return columns;
    }

    private void requireColumns(Map<String, Integer> columns, String... required) {
        for (String column : required) {
            if (!columns.containsKey(column)) {
                throw new IllegalArgumentException("Missing required Excel column: " + column);
            }
        }
    }

    private String value(Row row, Map<String, Integer> columns, String column, DataFormatter formatter) {
        Integer cellIndex = columns.get(column);
        return cellIndex == null ? null : formatter.formatCellValue(row.getCell(cellIndex)).trim();
    }

    private boolean blank(Row row, DataFormatter formatter) {
        for (int cellIndex = row.getFirstCellNum(); cellIndex < row.getLastCellNum(); cellIndex++) {
            if (!formatter.formatCellValue(row.getCell(cellIndex)).isBlank()) {
                return false;
            }
        }
        return true;
    }

    private String defaultStatus(String status) {
        return status == null || status.isBlank() ? "ACTIVE" : status.toUpperCase(Locale.ROOT);
    }

    private String normalize(String value) {
        return value.toLowerCase(Locale.ROOT).replaceAll("[^a-z0-9]", "");
    }

    public byte[] export() {
        return repository.export();
    }

    public byte[] template() {
        return "employeeId,name,department,unit,email,phone,internalPhone,designation,joiningDate,status\n"
                .getBytes(java.nio.charset.StandardCharsets.UTF_8);
    }

    public EmployeeListResponse programs(Long id) {
        get(id);
        return new EmployeeListResponse(List.of(), 0);
    }

    public EmployeeListResponse nominations(Long id) {
        get(id);
        return new EmployeeListResponse(List.of(), 0);
    }

    public EmployeeListResponse attendance(Long id) {
        get(id);
        return new EmployeeListResponse(List.of(), 0);
    }

    public AttendanceListResponse attendanceRecords(Long id) {
        get(id);
        return attendanceService.byEmployee(id);
    }

    public EmployeeListResponse certificates(Long id) {
        get(id);
        return new EmployeeListResponse(List.of(), 0);
    }

    public EmployeeListResponse trainingHistory(Long id) {
        get(id);
        return new EmployeeListResponse(List.of(), 0);
    }

}