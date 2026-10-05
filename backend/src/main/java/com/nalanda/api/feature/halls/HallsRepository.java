package com.nalanda.api.feature.halls;

import java.sql.ResultSet;
import java.util.List;
import java.util.Optional;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

@Repository
public class HallsRepository {

    private final JdbcTemplate jdbc;

    public HallsRepository(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
        ensureLocationColumn();
    }

    private void ensureLocationColumn() {
        Integer columns = jdbc.queryForObject("""
                SELECT COUNT(*) FROM information_schema.columns
                WHERE table_schema = DATABASE() AND table_name = 'halls' AND column_name = 'location'
                """, Integer.class);
        if (columns != null && columns == 0) {
            jdbc.execute("ALTER TABLE halls ADD COLUMN location VARCHAR(100) NULL AFTER hall_name");
        }
        jdbc.update("""
                UPDATE halls SET location = facilities, facilities = NULL
                WHERE location IS NULL AND facilities IN ('Ground Floor', '1st Floor')
                """);
    }

    public List<HallResponse> list() {
        return jdbc.query(selectSql() + " ORDER BY h.id", this::map);
    }

    public Optional<HallResponse> findById(Long id) {
        return jdbc.query(selectSql() + " WHERE h.id = ?", this::map, id)
                .stream().findFirst();
    }

    public HallResponse create(HallRequest request, byte[] photoData, String photoContentType) {
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbc.update(connection -> {
            var statement = connection.prepareStatement(
                    "INSERT INTO halls (hall_name, capacity, location, facilities, photo_data, photo_content_type, status) VALUES (?, ?, ?, ?, ?, ?, ?)",
                    new String[] { "id" });
            statement.setString(1, request.name());
            statement.setInt(2, request.capacity());
            statement.setString(3, request.location());
            statement.setString(4, request.facilities());
            statement.setBytes(5, photoData);
            statement.setString(6, photoContentType);
            statement.setString(7, "AVAILABLE");
            return statement;
        }, keyHolder);
        return findById(keyHolder.getKey().longValue()).orElseThrow();
    }

    public HallResponse update(Long id, HallRequest request) {
        jdbc.update("UPDATE halls SET hall_name = ?, capacity = ?, location = ?, facilities = ? WHERE id = ?",
                request.name(), request.capacity(), request.location(), request.facilities(), id);
        return findById(id).orElseThrow();
    }

    public HallResponse updatePhoto(Long id, byte[] photoData, String contentType) {
        jdbc.update("UPDATE halls SET photo_data = ?, photo_content_type = ? WHERE id = ?", photoData, contentType, id);
        return findById(id).orElseThrow();
    }

    public int delete(Long id) {
        return jdbc.update("DELETE FROM halls WHERE id = ?", id);
    }

    public Optional<HallPhoto> photo(Long id) {
        return jdbc.query("SELECT photo_data, photo_content_type FROM halls WHERE id = ? AND photo_data IS NOT NULL",
                (result, row) -> new HallPhoto(result.getBytes("photo_data"), result.getString("photo_content_type")), id)
                .stream().findFirst();
    }

    private HallResponse map(ResultSet result, int rowNumber) throws java.sql.SQLException {
        Long id = result.getLong("id");
        String contentType = result.getString("photo_content_type");
        return new HallResponse(id, result.getString("hall_name"), result.getInt("capacity"),
                result.getString("location"), result.getString("facilities"),
                result.getString("status"), contentType == null ? null : "/api/halls/" + id + "/photo");
    }

    private String selectSql() {
        return """
                SELECT h.id, h.hall_name, h.capacity, h.location, h.facilities,
                       CASE WHEN EXISTS (
                           SELECT 1 FROM program_halls ph JOIN programs p ON p.id = ph.program_id
                           WHERE ph.hall_id = h.id AND (
                             p.status = 'SCHEDULED'
                             OR (p.status = 'ONGOING'
                               AND (ph.from_date IS NULL OR ph.to_date IS NULL OR CURRENT_DATE BETWEEN ph.from_date AND ph.to_date))
                           )
                       ) THEN CASE WHEN EXISTS (
                           SELECT 1 FROM program_halls ph2 JOIN programs p2 ON p2.id = ph2.program_id
                           WHERE ph2.hall_id = h.id AND p2.status = 'ONGOING'
                             AND (ph2.from_date IS NULL OR ph2.to_date IS NULL OR CURRENT_DATE BETWEEN ph2.from_date AND ph2.to_date)
                       ) THEN 'IN_USE' ELSE 'BOOKED' END ELSE h.status END AS status,
                       h.photo_content_type
                FROM halls h
                """;
    }
}