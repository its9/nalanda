package com.nalanda.api.feature.feedback;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.Locale;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Service;

import com.nalanda.api.common.ResourceNotFoundException;

@Service
public class FeedbackService {

    private final JdbcTemplate jdbc;

    public FeedbackService(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public FeedbackListResponse list() {
        List<FeedbackResponse> items = jdbc.query(selectSql() + " ORDER BY f.id DESC", this::map);
        return new FeedbackListResponse(items, items.size());
    }

    public FeedbackResponse get(Long id) {
        List<FeedbackResponse> items = jdbc.query(selectSql() + " WHERE f.id = ?", this::map, id);
        return items.stream().findFirst().orElseThrow(() -> new ResourceNotFoundException("Feedback not found: " + id));
    }

    public FeedbackResponse create(FeedbackRequest request) {
        if (request == null) {
            throw new IllegalArgumentException("Feedback request is required");
        }
        Long programId = parseLong(request.programId());
        Long employeeId = parseLong(request.employeeId());
        LocalDate feedbackDate = request.feedbackDate() == null ? LocalDate.now() : request.feedbackDate();
        Integer rating = request.rating() == null ? Math.toIntExact(Math.round(avg(request.contentRating(), request.facultyRating(), request.facilityRating()))) : clampRating(request.rating());

        if (hasFeedbackForEmployeeProgram(programId, employeeId, null)) {
            throw new IllegalArgumentException("Feedback already exists for this employee and program");
        }

        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbc.update(connection -> {
            var statement = connection.prepareStatement(
                    "INSERT INTO feedback (program_id, employee_id, rating, comments, feedback_date) VALUES (?, ?, ?, ?, ?)",
                    new String[] { "id" });
            statement.setLong(1, programId);
            statement.setLong(2, employeeId);
            statement.setInt(3, rating);
            statement.setString(4, request.comments());
            statement.setDate(5, java.sql.Date.valueOf(feedbackDate));
            return statement;
        }, keyHolder);

        Long id = keyHolder.getKey() == null ? null : keyHolder.getKey().longValue();
        if (id == null) {
            throw new IllegalStateException("Failed to create feedback record");
        }
        return get(id);
    }

    public FeedbackResponse update(Long id, FeedbackRequest request) {
        get(id);
        Long programId = parseLong(request.programId());
        Long employeeId = parseLong(request.employeeId());
        Integer rating = request.rating() == null ? Math.toIntExact(Math.round(avg(request.contentRating(), request.facultyRating(), request.facilityRating()))) : clampRating(request.rating());

        if (hasFeedbackForEmployeeProgram(programId, employeeId, id)) {
            throw new IllegalArgumentException("Feedback already exists for this employee and program");
        }

        jdbc.update(
                "UPDATE feedback SET program_id = ?, employee_id = ?, rating = ?, comments = ?, feedback_date = ? WHERE id = ?",
                programId, employeeId, rating, request.comments(), request.feedbackDate() == null ? LocalDate.now() : request.feedbackDate(), id);
        return get(id);
    }

    public void delete(Long id) {
        int affected = jdbc.update("DELETE FROM feedback WHERE id = ?", id);
        if (affected == 0) {
            throw new ResourceNotFoundException("Feedback not found: " + id);
        }
    }

    public FeedbackListResponse byProgram(String programId) {
        Long filteredProgramId = parseLong(programId);
        List<FeedbackResponse> items = jdbc.query(selectSql() + " WHERE f.program_id = ? ORDER BY f.id DESC", this::map, filteredProgramId);
        return new FeedbackListResponse(items, items.size());
    }

    public FeedbackSummary summary(String programId) {
        List<FeedbackResponse> items = byProgram(programId).items();
        if (items.isEmpty()) {
            return new FeedbackSummary(programId, 0, 0, 0, 0, 0);
        }
        double content = items.stream().mapToDouble(FeedbackResponse::contentRating).average().orElse(0);
        double faculty = items.stream().mapToDouble(FeedbackResponse::facultyRating).average().orElse(0);
        double facility = items.stream().mapToDouble(FeedbackResponse::facilityRating).average().orElse(0);
        return new FeedbackSummary(programId, items.size(), round(content), round(faculty), round(facility),
                round((content + faculty + facility) / 3));
    }

    private String selectSql() {
        return "SELECT f.id, f.program_id, p.program_name, e.employee_name, d.dept_name, pt.type_name AS program_type, " +
                "f.rating, f.comments, 'REVIEWED' AS status, f.feedback_date, " +
                "f.rating AS content_rating, f.rating AS faculty_rating, f.rating AS facility_rating, f.rating AS overall_rating " +
                "FROM feedback f " +
                "JOIN programs p ON p.id = f.program_id " +
                "JOIN employees e ON e.id = f.employee_id " +
                "JOIN departments d ON d.id = e.department_id " +
                "JOIN program_types pt ON pt.id = p.program_type_id";
    }

    private FeedbackResponse map(ResultSet result, int rowNumber) throws SQLException {
        double rating = result.getDouble("rating");
        double overall = rating;
        double content = result.getDouble("content_rating");
        double faculty = result.getDouble("faculty_rating");
        double facility = result.getDouble("facility_rating");
        return new FeedbackResponse(
                result.getLong("id"),
                String.valueOf(result.getLong("program_id")),
                result.getString("program_name"),
                result.getString("employee_name"),
                result.getString("dept_name"),
                result.getString("program_type"),
                result.getInt("rating"),
                result.getString("comments"),
                result.getString("status"),
                result.getDate("feedback_date") == null ? null : result.getDate("feedback_date").toLocalDate(),
                round(content),
                round(faculty),
                round(facility),
                round(overall));
    }

    private boolean hasFeedbackForEmployeeProgram(Long programId, Long employeeId, Long excludeId) {
        if (excludeId == null) {
            Integer count = jdbc.queryForObject(
                    "SELECT COUNT(*) FROM feedback WHERE program_id = ? AND employee_id = ?",
                    Integer.class,
                    programId,
                    employeeId);
            return count != null && count > 0;
        }

        Integer count = jdbc.queryForObject(
                "SELECT COUNT(*) FROM feedback WHERE program_id = ? AND employee_id = ? AND id != ?",
                Integer.class,
                programId,
                employeeId,
                excludeId);
        return count != null && count > 0;
    }

    private Long parseLong(String value) {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException("Program or employee id is required");
        }
        try {
            return Long.parseLong(value.trim());
        } catch (NumberFormatException error) {
            throw new IllegalArgumentException("Invalid numeric value: " + value, error);
        }
    }

    private int clampRating(Integer value) {
        if (value == null) {
            return 3;
        }
        return Math.max(1, Math.min(5, value));
    }

    private String normalizeStatus(String status) {
        if (status == null || status.isBlank()) {
            return "REVIEWED";
        }
        return status.trim().toUpperCase(Locale.ROOT);
    }

    private double avg(double first, double second, double third) {
        return (first + second + third) / 3.0;
    }

    private double round(double value) {
        return Math.round(value * 10.0) / 10.0;
    }
}