CREATE TABLE program_faculty (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    program_id BIGINT NOT NULL,
    faculty_id BIGINT NOT NULL,
    faculty_role VARCHAR(50) DEFAULT 'FACULTY',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_program_faculty_program FOREIGN KEY (program_id) REFERENCES programs(id) ON DELETE CASCADE,
    CONSTRAINT fk_program_faculty_faculty FOREIGN KEY (faculty_id) REFERENCES faculty(id) ON DELETE RESTRICT,
    UNIQUE (program_id, faculty_id)
);
