package com.nalanda.api.feature.attendance;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import com.nalanda.api.common.ResourceNotFoundException;

@Service
public class AttendanceService {

    private final JdbcTemplate jdbc;

    public AttendanceService(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public AttendanceListResponse list() {
        List<AttendanceResponse> items = query("""
                SELECT a.id, a.program_id, a.employee_id, a.attendance_date, a.status, a.remarks,
                       p.program_name, e.employee_number, e.employee_name, u.unit_name AS wing,
                       (SELECT GROUP_CONCAT(h.hall_name SEPARATOR ', ') FROM program_halls ph JOIN halls h ON h.id = ph.hall_id WHERE ph.program_id = a.program_id) AS hall, NULL AS gender
                FROM attendance a
                JOIN programs p ON p.id = a.program_id
                JOIN employees e ON e.id = a.employee_id
                LEFT JOIN units u ON u.id = e.unit_id
                ORDER BY a.attendance_date DESC, a.id DESC
                """);
        return new AttendanceListResponse(items, items.size());
    }

    public long reportCount() {
        return jdbc.queryForObject("SELECT COUNT(*) FROM attendance", Long.class);
    }

    public AttendanceResponse get(Long id) {
        return jdbc.query("""
                SELECT a.id, a.program_id, a.employee_id, a.attendance_date, a.status, a.remarks,
                       p.program_name, e.employee_number, e.employee_name, u.unit_name AS wing,
                       (SELECT GROUP_CONCAT(h.hall_name SEPARATOR ', ') FROM program_halls ph JOIN halls h ON h.id = ph.hall_id WHERE ph.program_id = a.program_id) AS hall, NULL AS gender
                FROM attendance a JOIN programs p ON p.id = a.program_id
                JOIN employees e ON e.id = a.employee_id LEFT JOIN units u ON u.id = e.unit_id
                WHERE a.id = ?
                """, this::map, id).stream().findFirst()
                .orElseThrow(() -> new ResourceNotFoundException("Attendance record not found: " + id));
    }

    public AttendanceResponse create(AttendanceRequest request) {
        jdbc.update("""
                INSERT INTO attendance (program_id, employee_id, attendance_date, status, remarks)
                VALUES (?, ?, ?, ?, ?)
                ON DUPLICATE KEY UPDATE status = VALUES(status), remarks = VALUES(remarks)
                """, request.programId(), request.employeeId(), Date.valueOf(request.date()),
                request.status().toUpperCase(), request.remarks());
        Long id = jdbc.queryForObject("SELECT id FROM attendance WHERE program_id = ? AND employee_id = ? AND attendance_date = ?",
                Long.class, request.programId(), request.employeeId(), Date.valueOf(request.date()));
        return get(id);
    }

    public AttendanceResponse update(Long id, AttendanceRequest request) {
        get(id);
        jdbc.update("UPDATE attendance SET program_id = ?, employee_id = ?, attendance_date = ?, status = ?, remarks = ? WHERE id = ?",
                request.programId(), request.employeeId(), Date.valueOf(request.date()),
                request.status().toUpperCase(), request.remarks(), id);
        return get(id);
    }

    public AttendanceListResponse bulk(List<AttendanceRequest> requests) {
        if (requests == null) {
            return new AttendanceListResponse(List.of(), 0);
        }
        requests.forEach(this::create);
        return list();
    }

    public AttendanceListResponse byProgram(Long programId) {
        return new AttendanceListResponse(query("""
                SELECT a.id, a.program_id, a.employee_id, a.attendance_date, a.status, a.remarks,
                       p.program_name, e.employee_number, e.employee_name, u.unit_name AS wing,
                       (SELECT GROUP_CONCAT(h.hall_name SEPARATOR ', ') FROM program_halls ph JOIN halls h ON h.id = ph.hall_id WHERE ph.program_id = a.program_id) AS hall, NULL AS gender
                FROM attendance a JOIN programs p ON p.id = a.program_id
                JOIN employees e ON e.id = a.employee_id LEFT JOIN units u ON u.id = e.unit_id
                WHERE a.program_id = ? ORDER BY a.attendance_date DESC, a.id DESC
                """, programId), count(programId));
    }

    public AttendanceListResponse byEmployee(Long employeeId) {
        List<AttendanceResponse> items = query("""
                SELECT a.id, a.program_id, a.employee_id, a.attendance_date, a.status, a.remarks,
                       p.program_name, e.employee_number, e.employee_name, u.unit_name AS wing,
                       (SELECT GROUP_CONCAT(h.hall_name SEPARATOR ', ') FROM program_halls ph JOIN halls h ON h.id = ph.hall_id WHERE ph.program_id = a.program_id) AS hall, NULL AS gender
                FROM attendance a JOIN programs p ON p.id = a.program_id
                JOIN employees e ON e.id = a.employee_id LEFT JOIN units u ON u.id = e.unit_id
                WHERE a.employee_id = ? ORDER BY a.attendance_date DESC, a.id DESC
                """, employeeId);
        return new AttendanceListResponse(items, items.size());
    }

    public AttendanceSummary summary(Long programId) {
        List<AttendanceResponse> items = byProgram(programId).items();
        int present = (int) items.stream().filter(record -> "PRESENT".equalsIgnoreCase(record.status())).count();
        int nominated = jdbc.queryForObject("SELECT COUNT(*) FROM nominations WHERE program_id = ? AND status IN ('NOMINATED', 'APPROVED')",
                Integer.class, programId);
        int absent = Math.max(0, nominated - present);
        double percentage = nominated == 0 ? 0 : present * 100.0 / nominated;
        return new AttendanceSummary(nominated, present, absent, percentage);
    }

    public AttendanceListResponse nominatedEmployee(String employeeNumber) {
        List<AttendanceResponse> items = jdbc.query("""
                SELECT NULL, n.program_id, e.id, p.start_date, 'ABSENT', NULL, p.program_name,
                       e.employee_number, e.employee_name, u.unit_name, NULL, NULL
                FROM nominations n JOIN employees e ON e.id = n.employee_id
                JOIN programs p ON p.id = n.program_id
                LEFT JOIN units u ON u.id = e.unit_id
                WHERE e.employee_number = ? AND n.status IN ('PENDING', 'NOMINATED', 'APPROVED')
                ORDER BY p.start_date DESC, p.program_name
                """, this::map, employeeNumber);
        return new AttendanceListResponse(items, items.size());
    }

    public AttendanceListResponse nominatedProgram(Long programId, LocalDate date) {
        LocalDate attendanceDate = date == null ? LocalDate.now() : date;
        List<AttendanceResponse> items = jdbc.query("""
                SELECT a.id, n.program_id, e.id, ?, COALESCE(a.status, 'ABSENT'), a.remarks,
                       p.program_name, e.employee_number, e.employee_name, u.unit_name, NULL, NULL
                FROM nominations n
                JOIN employees e ON e.id = n.employee_id
                JOIN programs p ON p.id = n.program_id
                LEFT JOIN units u ON u.id = e.unit_id
                LEFT JOIN attendance a ON a.program_id = n.program_id
                    AND a.employee_id = n.employee_id AND a.attendance_date = ?
                WHERE n.program_id = ? AND n.status IN ('PENDING', 'NOMINATED', 'APPROVED')
                ORDER BY e.employee_name
                """, this::map, Date.valueOf(attendanceDate), Date.valueOf(attendanceDate), programId);
        return new AttendanceListResponse(items, items.size());
    }

    private List<AttendanceResponse> query(String sql, Object... args) {
        return jdbc.query(sql, this::map, args);
    }

    private long count(Long programId) {
        return jdbc.queryForObject("SELECT COUNT(*) FROM attendance WHERE program_id = ?", Long.class, programId);
    }

    private AttendanceResponse map(java.sql.ResultSet result, int row) throws java.sql.SQLException {
        Date date = result.getDate(4);
        return new AttendanceResponse(result.getLong(1), result.getLong(2), result.getLong(3),
                date == null ? null : date.toLocalDate(), result.getString(5), result.getString(7),
                result.getString(8), result.getString(9), result.getString(10), result.getString(11),
                result.getString(12), result.getString(6));
    }
}