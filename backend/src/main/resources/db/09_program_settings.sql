CREATE TABLE program_settings (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    program_id BIGINT NOT NULL UNIQUE,
    max_participants INT DEFAULT 0,
    min_participants INT DEFAULT 0,
    allow_repeat BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    notes TEXT,
    CONSTRAINT fk_program_settings_program FOREIGN KEY (program_id) REFERENCES programs(id) ON DELETE CASCADE
);
