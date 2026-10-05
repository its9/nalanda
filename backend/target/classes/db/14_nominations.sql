CREATE TABLE nominations (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    program_id BIGINT NOT NULL,
    employee_id BIGINT NOT NULL,
    nomination_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'NOMINATED',
    remarks TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_nomination_program FOREIGN KEY (program_id) REFERENCES programs(id) ON DELETE CASCADE,
    CONSTRAINT fk_nomination_employee FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE RESTRICT,
    UNIQUE (program_id, employee_id)
);
