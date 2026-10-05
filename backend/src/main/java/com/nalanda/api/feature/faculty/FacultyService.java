package com.nalanda.api.feature.faculty;

import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import com.nalanda.api.common.ResourceNotFoundException;

@Service
public class FacultyService {

    private final JdbcTemplate jdbc;

    public FacultyService(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public FacultyListResponse list() {
        List<FacultyResponse> items = jdbc.query("""
                SELECT id, faculty_name, email, organization, designation, faculty_type, status,
                       CASE WHEN photo_data IS NULL THEN NULL ELSE CONCAT('/api/faculty/', id, '/photo') END AS photo_url
                FROM faculty ORDER BY id
                """, this::map);
        return new FacultyListResponse(items, items.size());
    }

    public long reportCount() {
        return jdbc.queryForObject("SELECT COUNT(*) FROM faculty", Long.class);
    }

    public FacultyResponse get(Long id) {
        return jdbc.query("""
                SELECT id, faculty_name, email, organization, designation, faculty_type, status,
                       CASE WHEN photo_data IS NULL THEN NULL ELSE CONCAT('/api/faculty/', id, '/photo') END AS photo_url
                FROM faculty WHERE id = ?
                """, this::map, id).stream().findFirst()
                .orElseThrow(() -> new ResourceNotFoundException("Faculty member not found: " + id));
    }

    public FacultyResponse create(FacultyRequest request) {
        jdbc.update("""
                INSERT INTO faculty (faculty_name, email, organization, designation, faculty_type, status)
                VALUES (?, ?, ?, ?, ?, ?)
                """, request.name(), request.email(), request.organization(),
                request.specialization(), request.type(), request.status());
        return get(jdbc.queryForObject("SELECT LAST_INSERT_ID()", Long.class));
    }

    public FacultyResponse update(Long id, FacultyRequest request) {
        get(id);
        jdbc.update("""
                UPDATE faculty SET faculty_name = ?, email = ?, organization = ?,
                designation = ?, faculty_type = ?, status = ? WHERE id = ?
                """, request.name(), request.email(), request.organization(),
                request.specialization(), request.type(), request.status(), id);
        return get(id);
    }

    public FacultyResponse create(FacultyRequest request, byte[] photo, String contentType) {
        jdbc.update("""
                INSERT INTO faculty (faculty_name, email, organization, designation, faculty_type, status, photo_data, photo_content_type)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                """, request.name(), request.email(), request.organization(), request.specialization(),
                request.type(), request.status(), photo, contentType);
        return get(jdbc.queryForObject("SELECT LAST_INSERT_ID()", Long.class));
    }

    public FacultyResponse update(Long id, FacultyRequest request, byte[] photo, String contentType) {
        get(id);
        if (photo == null) {
            jdbc.update("""
                    UPDATE faculty SET faculty_name = ?, email = ?, organization = ?,
                    designation = ?, faculty_type = ?, status = ? WHERE id = ?
                    """, request.name(), request.email(), request.organization(),
                    request.specialization(), request.type(), request.status(), id);
        } else {
            jdbc.update("""
                    UPDATE faculty SET faculty_name = ?, email = ?, organization = ?,
                    designation = ?, faculty_type = ?, status = ?, photo_data = ?, photo_content_type = ? WHERE id = ?
                    """, request.name(), request.email(), request.organization(),
                    request.specialization(), request.type(), request.status(), photo, contentType, id);
        }
        return get(id);
    }

    public byte[] photo(Long id) {
        return jdbc.query("SELECT photo_data FROM faculty WHERE id = ? AND photo_data IS NOT NULL",
                (result, row) -> result.getBytes("photo_data"), id).stream().findFirst()
                .orElseThrow(() -> new ResourceNotFoundException("Faculty photo not found: " + id));
    }

    public String photoContentType(Long id) {
        return jdbc.query("SELECT photo_content_type FROM faculty WHERE id = ? AND photo_data IS NOT NULL",
                (result, row) -> result.getString("photo_content_type"), id).stream().findFirst()
                .orElseThrow(() -> new ResourceNotFoundException("Faculty photo not found: " + id));
    }

    public void delete(Long id) {
        if (jdbc.update("DELETE FROM faculty WHERE id = ?", id) == 0) {
            throw new ResourceNotFoundException("Faculty member not found: " + id);
        }
    }

    public FacultyRelatedResponse programs(Long id) {
        get(id);
        return new FacultyRelatedResponse(List.of(), 0);
    }

    public FacultyRelatedResponse history(Long id) {
        get(id);
        return new FacultyRelatedResponse(List.of(), 0);
    }

    public FacultyStatistics statistics(Long id) {
        get(id);
        return new FacultyStatistics(id, 0, 0, 0, 0);
    }

    private FacultyResponse map(java.sql.ResultSet result, int row) throws java.sql.SQLException {
        return new FacultyResponse(result.getLong("id"), result.getString("faculty_name"),
                result.getString("email"), result.getString("organization"),
                result.getString("designation"), result.getString("faculty_type"),
                result.getString("status"), result.getString("photo_url"));
    }
}