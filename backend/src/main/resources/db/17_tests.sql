CREATE TABLE tests (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    program_id BIGINT NOT NULL,
    test_type VARCHAR(20) NOT NULL,
    total_marks INT NOT NULL,
    passing_marks INT,
    description TEXT,
    CONSTRAINT fk_test_program FOREIGN KEY (program_id) REFERENCES programs(id) ON DELETE CASCADE,
    CHECK (test_type IN ('PRE_TEST', 'POST_TEST'))
);
