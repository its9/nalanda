CREATE TABLE feedback (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    program_id BIGINT NOT NULL,
    employee_id BIGINT NOT NULL,
    rating INT,
    comments TEXT,
    feedback_date DATE DEFAULT (CURRENT_DATE),
    CONSTRAINT fk_feedback_program FOREIGN KEY (program_id) REFERENCES programs(id) ON DELETE CASCADE,
    CONSTRAINT fk_feedback_employee FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE RESTRICT,
    CHECK (rating >= 1 AND rating <= 5)
);
