CREATE TABLE programs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    batch_number VARCHAR(50) NOT NULL,
    program_code VARCHAR(50) NOT NULL UNIQUE,
    program_name VARCHAR(200) NOT NULL,
    program_type_id BIGINT NOT NULL,
    start_date DATE,
    end_date DATE,
    num_days INT NOT NULL DEFAULT 0,
    total_hours DECIMAL(8,2) DEFAULT 0,
    description TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'PLANNED',
    created_by BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_program_type FOREIGN KEY (program_type_id) REFERENCES program_types(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_program_created_by FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
);
