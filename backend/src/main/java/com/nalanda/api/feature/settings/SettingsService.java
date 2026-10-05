package com.nalanda.api.feature.settings;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.sql.Timestamp;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.annotation.PostConstruct;

@Service
public class SettingsService {

    private final JdbcTemplate jdbc;
    private final ObjectMapper objectMapper;

    public SettingsService(JdbcTemplate jdbc, ObjectMapper objectMapper) {
        this.jdbc = jdbc;
        this.objectMapper = objectMapper;
    }

    @PostConstruct
    void createSettingsTable() {
        jdbc.execute("""
            CREATE TABLE IF NOT EXISTS application_settings (
                scope VARCHAR(100) PRIMARY KEY,
                settings_json MEDIUMTEXT NOT NULL,
                updated_at TIMESTAMP NOT NULL
            )
            """);
        jdbc.execute("ALTER TABLE application_settings MODIFY settings_json MEDIUMTEXT NOT NULL");
    }

    public SettingsResponse get(String scope) {
        return jdbc.query("SELECT settings_json FROM application_settings WHERE scope = ?",
                (result, row) -> parse(result.getString("settings_json")), scope)
            .stream()
            .findFirst()
            .map(values -> new SettingsResponse(scope, values))
            .orElseGet(() -> new SettingsResponse(scope, Map.of()));
    }

    public SettingsResponse update(String scope, Map<String, Object> values) {
        Map<String, Object> copy = new LinkedHashMap<>(values == null ? Map.of() : values);
        String json = serialize(copy);
        jdbc.update("""
            INSERT INTO application_settings (scope, settings_json, updated_at)
            VALUES (?, ?, ?)
            ON DUPLICATE KEY UPDATE settings_json = VALUES(settings_json), updated_at = VALUES(updated_at)
            """, scope, json, Timestamp.from(java.time.Instant.now()));
        return new SettingsResponse(scope, copy);
    }

    private Map<String, Object> parse(String json) {
        try {
            return objectMapper.readValue(json, new TypeReference<>() {});
        } catch (JsonProcessingException exception) {
            throw new IllegalStateException("Stored settings are invalid JSON", exception);
        }
    }

    private String serialize(Map<String, Object> values) {
        try {
            return objectMapper.writeValueAsString(values);
        } catch (JsonProcessingException exception) {
            throw new IllegalArgumentException("Settings contain unsupported values", exception);
        }
    }
}