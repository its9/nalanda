CREATE TABLE test_results (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    test_id BIGINT NOT NULL,
    employee_id BIGINT NOT NULL,
    marks_obtained INT NOT NULL,
    percentage DECIMAL(5,2),
    result VARCHAR(20),
    attempt_date DATE DEFAULT (CURRENT_DATE),
    CONSTRAINT fk_test_result_test FOREIGN KEY (test_id) REFERENCES tests(id) ON DELETE CASCADE,
    CONSTRAINT fk_test_result_employee FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE RESTRICT
);
