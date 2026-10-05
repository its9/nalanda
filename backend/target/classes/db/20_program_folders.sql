CREATE TABLE program_folders (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    program_id BIGINT NOT NULL UNIQUE,
    folder_path VARCHAR(500) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_program_folder_program FOREIGN KEY (program_id) REFERENCES programs(id) ON DELETE CASCADE
);
