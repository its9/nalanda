CREATE TABLE application_settings (
    scope VARCHAR(100) PRIMARY KEY,
    settings_json MEDIUMTEXT NOT NULL,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
