package com.nalanda.api.feature.nominations;

import java.nio.charset.StandardCharsets;
import java.util.List;
import java.time.LocalDate;
import org.springframework.jdbc.core.JdbcTemplate;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.apache.poi.ss.usermodel.WorkbookFactory;

import com.nalanda.api.common.ResourceNotFoundException;

@Service
public class NominationsService {

    private final JdbcTemplate jdbc;

    public NominationsService(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public NominationListResponse list() {
        List<NominationResponse> items = jdbc.query("SELECT n.id, n.program_id, n.employee_id, n.status, n.remarks, n.nomination_date, e.employee_number, e.employee_name, p.program_name FROM nominations n JOIN employees e ON e.id = n.employee_id JOIN programs p ON p.id = n.program_id ORDER BY n.id",
                (result, row) -> new NominationResponse(result.getLong("id"), result.getLong("program_id"),
                        result.getLong("employee_id"), result.getString("status"), result.getString("remarks"),
                        result.getString("employee_number"), result.getString("employee_name"),
                        result.getString("program_name"), result.getDate("nomination_date").toLocalDate()));
        return new NominationListResponse(items, items.size());
    }

    public long reportCount() {
        return jdbc.queryForObject("SELECT COUNT(*) FROM nominations", Long.class);
    }

    public NominationResponse get(Long id) {
        List<NominationResponse> items = jdbc.query("SELECT n.id, n.program_id, n.employee_id, n.status, n.remarks, n.nomination_date, e.employee_number, e.employee_name, p.program_name FROM nominations n JOIN employees e ON e.id = n.employee_id JOIN programs p ON p.id = n.program_id WHERE n.id = ?",
                (result, row) -> new NominationResponse(result.getLong("id"), result.getLong("program_id"),
                        result.getLong("employee_id"), result.getString("status"), result.getString("remarks"),
                        result.getString("employee_number"), result.getString("employee_name"),
                        result.getString("program_name"), result.getDate("nomination_date").toLocalDate()), id);
        if (items.isEmpty()) {
            throw new ResourceNotFoundException("Nomination not found: " + id);
        }
        return items.get(0);
    }

    public NominationResponse create(NominationRequest request) {
        jdbc.update("INSERT INTO nominations (program_id, employee_id, nomination_date, status, remarks) VALUES (?, ?, ?, ?, ?)",
                request.programId(), request.employeeId(), LocalDate.now(), "PENDING", request.remarks());
        return get(jdbc.queryForObject("SELECT LAST_INSERT_ID()", Long.class));
    }

    public NominationResponse update(Long id, NominationRequest request) {
        NominationResponse current = get(id);
        validateStatusTransition(current.status(), request.status());
        jdbc.update("UPDATE nominations SET program_id = ?, employee_id = ?, status = ?, remarks = ? WHERE id = ?",
                request.programId(), request.employeeId(), normalizeStatus(request.status()), request.remarks(), id);
        return get(id);
    }

    public void delete(Long id) {
        if (jdbc.update("DELETE FROM nominations WHERE id = ?", id) == 0) {
            throw new ResourceNotFoundException("Nomination not found: " + id);
        }
    }

    public NominationResponse decide(Long id, String status) {
        NominationResponse current = get(id);
        validateStatusTransition(current.status(), status);
        jdbc.update("UPDATE nominations SET status = ? WHERE id = ?", normalizeStatus(status), id);
        return get(id);
    }

    private void validateStatusTransition(String current, String next) {
        if (!"PENDING".equalsIgnoreCase(current)) {
            throw new IllegalStateException("Only pending nominations can be approved or cancelled");
        }
        if (!"APPROVED".equalsIgnoreCase(next) && !"CANCELLED".equalsIgnoreCase(next)) {
            throw new IllegalArgumentException("Nomination status can only be APPROVED or CANCELLED");
        }
    }

    private String normalizeStatus(String status) {
        return status == null ? "" : status.trim().toUpperCase();
    }

    public NominationBulkResponse bulk(List<NominationRequest> requests) {
        if (requests == null) {
            return new NominationBulkResponse(0, "No nominations supplied");
        }
        requests.forEach(this::create);
        return new NominationBulkResponse(requests.size(), "Nominations created");
    }

    public NominationListResponse byProgram(Long programId) {
        return listBy("program_id", programId);
    }

    public int countByProgram(Long programId) {
        return jdbc.queryForObject("SELECT COUNT(*) FROM nominations WHERE program_id = ?", Integer.class, programId);
    }

    public NominationListResponse byEmployee(Long employeeId) {
        return listBy("employee_id", employeeId);
    }

    public NominationBulkResponse importFile(MultipartFile file, Long programId) {
        if (file == null || file.isEmpty()) return new NominationBulkResponse(0, "No nomination file was uploaded");
        if (programId == null) return new NominationBulkResponse(0, "A program is required for the employee list");
        int created = 0;
        try (var workbook = WorkbookFactory.create(file.getInputStream())) {
            var sheet = workbook.getSheetAt(0);
            for (int rowIndex = 1; rowIndex <= sheet.getLastRowNum(); rowIndex++) {
                var row = sheet.getRow(rowIndex);
                if (row == null || row.getCell(0) == null) continue;
                String employeeNumber = row.getCell(0).toString().trim();
                if (employeeNumber.isBlank()) continue;
                var employeeId = jdbc.query("SELECT id FROM employees WHERE employee_number = ?",
                        (result, number) -> result.getLong("id"), employeeNumber).stream().findFirst();
                if (employeeId.isEmpty()) continue;
                created += jdbc.update("INSERT IGNORE INTO nominations (program_id, employee_id, nomination_date, status) VALUES (?, ?, CURRENT_DATE, 'PENDING')",
                        programId, employeeId.get());
            }
            return new NominationBulkResponse(created, "Employee nominations imported");
        } catch (Exception exception) {
            throw new IllegalArgumentException("Employee list could not be read", exception);
        }
    }

    public byte[] export() {
        StringBuilder csv = new StringBuilder("id,programId,employeeId,status,remarks\n");
        list().items().forEach(nomination -> csv.append(nomination.id()).append(',').append(nomination.programId()).append(',')
                .append(nomination.employeeId()).append(',').append(nomination.status()).append(',')
                .append(nomination.remarks() == null ? "" : nomination.remarks()).append('\n'));
        return csv.toString().getBytes(StandardCharsets.UTF_8);
    }

    public byte[] template() {
        return "programId,employeeId,status,remarks\n101,1001,PENDING,Optional remarks\n"
                .getBytes(StandardCharsets.UTF_8);
    }

    private NominationListResponse filter(java.util.function.Predicate<NominationResponse> predicate) {
        List<NominationResponse> items = list().items().stream().filter(predicate).toList();
        return new NominationListResponse(items, items.size());
    }

    private NominationListResponse listBy(String column, Long value) {
        return filter(nomination -> (column.equals("program_id") ? nomination.programId() : nomination.employeeId()).equals(value));
    }

    private NominationResponse toResponse(Long id, NominationRequest request) {
        return new NominationResponse(id, request.programId(), request.employeeId(), request.status(), request.remarks(), null, null, null, null);
    }
}