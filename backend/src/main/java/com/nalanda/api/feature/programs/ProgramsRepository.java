package com.nalanda.api.feature.programs;

import java.sql.PreparedStatement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import com.nalanda.api.common.ResourceNotFoundException;

@Repository
public class ProgramsRepository {

    private final JdbcTemplate jdbc;

    public ProgramsRepository(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public List<ProgramResponse> list(String unit, String type, String status, Integer year, Integer month) {
        StringBuilder sql = new StringBuilder(selectSql()).append(" WHERE 1 = 1");
        List<Object> args = new ArrayList<>();
        if (type != null && !type.isBlank()) { sql.append(" AND LOWER(pt.type_name) = LOWER(?)"); args.add(type); }
        if (status != null && !status.isBlank()) { sql.append(" AND LOWER(p.status) = LOWER(?)"); args.add(status); }
        if (year != null) { sql.append(" AND YEAR(p.start_date) = ?"); args.add(year); }
        if (month != null) { sql.append(" AND MONTH(p.start_date) = ?"); args.add(month); }
        sql.append(" ORDER BY p.id");
        return jdbc.query(sql.toString(), this::map, args.toArray());
    }

    public Optional<ProgramResponse> findById(Long id) {
        return jdbc.query(selectSql() + " WHERE p.id = ?", this::map, id).stream().findFirst();
    }

    public List<ProgramResponse> search(String name) {
        return jdbc.query(selectSql() + " WHERE LOWER(p.program_name) LIKE LOWER(?) ORDER BY p.id", this::map,
                "%" + (name == null ? "" : name) + "%");
    }

    public ProgramResponse create(ProgramRequest request) {
        Long programTypeId = findProgramTypeId(request.type());
        LocalDate startDate = scheduleDate(request.startDate(), request.endDate(), request.status(), true);
        LocalDate endDate = scheduleDate(request.startDate(), request.endDate(), request.status(), false);
        int programDays = calculateDays(startDate, endDate);
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbc.update(connection -> {
            PreparedStatement statement = connection.prepareStatement(
                "INSERT INTO programs (batch_number, program_code, program_name, description, program_type_id, start_date, end_date, num_days, total_hours, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                    new String[] { "id" });
            statement.setString(1, request.batchNumber());
            statement.setString(2, request.code());
            statement.setString(3, request.name());
            statement.setString(4, request.coordinator());
            statement.setLong(5, programTypeId);
            setDate(statement, 6, startDate);
            setDate(statement, 7, endDate);
            statement.setInt(8, programDays);
            statement.setInt(9, programDays * request.hoursPerDay());
            statement.setString(10, request.status());
            return statement;
        }, keyHolder);
        Long id = keyHolder.getKey().longValue();
        syncHall(id, request.hall(), startDate, endDate);
        return findById(id).orElseThrow();
    }

    public ProgramResponse update(Long id, ProgramRequest request) {
        findById(id).orElseThrow(() -> new ResourceNotFoundException("Program not found: " + id));
        Long programTypeId = findProgramTypeId(request.type());
        LocalDate startDate = scheduleDate(request.startDate(), request.endDate(), request.status(), true);
        LocalDate endDate = scheduleDate(request.startDate(), request.endDate(), request.status(), false);
        int programDays = calculateDays(startDate, endDate);
        jdbc.update("UPDATE programs SET batch_number = ?, program_code = ?, program_name = ?, description = ?, program_type_id = ?, start_date = ?, end_date = ?, num_days = ?, total_hours = ?, status = ? WHERE id = ?",
            request.batchNumber(), request.code(), request.name(), request.coordinator(), programTypeId,
                startDate == null ? null : java.sql.Date.valueOf(startDate),
                endDate == null ? null : java.sql.Date.valueOf(endDate),
                programDays, programDays * request.hoursPerDay(), request.status(), id);
        syncHall(id, request.hall(), startDate, endDate);
        return findById(id).orElseThrow();
    }

    public int delete(Long id) {
        return jdbc.update("DELETE FROM programs WHERE id = ?", id);
    }

    public ProgramResponse updateStatus(Long id, String status) {
        findById(id).orElseThrow(() -> new ResourceNotFoundException("Program not found: " + id));
        jdbc.update("UPDATE programs SET status = ? WHERE id = ?", status, id);
        return findById(id).orElseThrow();
    }

    private Long findProgramTypeId(String value) {
        return jdbc.query("SELECT id FROM program_types WHERE LOWER(type_name) = LOWER(?) LIMIT 1",
                (result, row) -> result.getLong("id"), value).stream().findFirst()
                .orElseThrow(() -> new ResourceNotFoundException("Program type not found: " + value));
    }

    private String selectSql() {
        return "SELECT p.id, p.batch_number, p.program_code, p.program_name, p.description, pt.type_name AS program_type, CASE WHEN p.status = 'CANCELLED' THEN 'CANCELLED' WHEN p.status = 'PLANNED' THEN 'PLANNED' WHEN p.start_date IS NOT NULL AND p.end_date IS NOT NULL AND CURRENT_DATE > p.end_date THEN 'COMPLETED' WHEN p.start_date IS NOT NULL AND p.end_date IS NOT NULL AND CURRENT_DATE BETWEEN p.start_date AND p.end_date THEN 'ONGOING' WHEN p.status IN ('SCHEDULED', 'ONGOING') THEN 'SCHEDULED' ELSE p.status END AS effective_status, YEAR(p.start_date) AS program_year, MONTH(p.start_date) AS program_month, p.num_days, p.total_hours, p.start_date, p.end_date, h.hall_name AS hall_name FROM programs p JOIN program_types pt ON pt.id = p.program_type_id LEFT JOIN program_halls ph ON ph.program_id = p.id LEFT JOIN halls h ON h.id = ph.hall_id";
    }

    private ProgramResponse map(java.sql.ResultSet result, int rowNumber) throws java.sql.SQLException {
        int programDays = result.getInt("num_days");
        double totalHours = result.getBigDecimal("total_hours").doubleValue();
        java.sql.Date startSqlDate = result.getDate("start_date");
        java.sql.Date endSqlDate = result.getDate("end_date");
        LocalDate startDate = startSqlDate == null ? null : startSqlDate.toLocalDate();
        LocalDate endDate = endSqlDate == null ? null : endSqlDate.toLocalDate();
        return new ProgramResponse(result.getLong("id"), result.getString("batch_number"), result.getString("program_code"), result.getString("program_name"), result.getString("description"),
            null, result.getString("hall_name"), result.getString("program_type"), result.getString("effective_status"),
            startDate == null ? null : result.getInt("program_year"), startDate == null ? null : result.getInt("program_month"), programDays,
            programDays == 0 ? 0 : (int) Math.round(totalHours / programDays),
            startDate, endDate);
    }

    private void syncHall(Long programId, String hallName, LocalDate startDate, LocalDate endDate) {
        if (hallName == null || hallName.isBlank()) {
            jdbc.update("DELETE FROM program_halls WHERE program_id = ?", programId);
            return;
        }
        Long hallId = jdbc.query("SELECT id FROM halls WHERE hall_name = ? LIMIT 1",
                (result, row) -> result.getLong("id"), hallName).stream().findFirst()
                .orElseThrow(() -> new ResourceNotFoundException("Hall not found: " + hallName));
        if (startDate != null && endDate != null && jdbc.queryForObject("""
                SELECT COUNT(*) FROM program_halls ph
                JOIN programs p ON p.id = ph.program_id
                WHERE ph.hall_id = ? AND ph.program_id <> ?
                  AND p.status IN ('SCHEDULED', 'ONGOING')
                  AND ph.from_date <= ? AND ph.to_date >= ?
                """, Integer.class, hallId, programId, java.sql.Date.valueOf(endDate), java.sql.Date.valueOf(startDate)) > 0) {
            throw new IllegalArgumentException("The selected hall is not available for the selected dates");
        }
        jdbc.update("DELETE FROM program_halls WHERE program_id = ?", programId);
        jdbc.update("INSERT INTO program_halls (program_id, hall_id, from_date, to_date) VALUES (?, ?, ?, ?)",
                programId, hallId, startDate == null ? null : java.sql.Date.valueOf(startDate),
                endDate == null ? null : java.sql.Date.valueOf(endDate));
    }

    private LocalDate scheduleDate(LocalDate startDate, LocalDate endDate, String status, boolean start) {
        if ("PLANNED".equalsIgnoreCase(status) || "CANCELLED".equalsIgnoreCase(status)) return null;
        if (startDate == null || endDate == null) {
            throw new IllegalArgumentException("Start date and end date are required for scheduled programs");
        }
        if (endDate.isBefore(startDate)) {
            throw new IllegalArgumentException("End date cannot be before start date");
        }
        return start ? startDate : endDate;
    }

    private int calculateDays(LocalDate startDate, LocalDate endDate) {
        return startDate == null ? 0 : (int) java.time.temporal.ChronoUnit.DAYS.between(startDate, endDate) + 1;
    }

    private void setDate(PreparedStatement statement, int index, LocalDate date) throws java.sql.SQLException {
        if (date == null) statement.setNull(index, java.sql.Types.DATE);
        else statement.setDate(index, java.sql.Date.valueOf(date));
    }
}
