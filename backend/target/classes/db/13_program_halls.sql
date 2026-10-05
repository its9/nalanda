CREATE TABLE program_halls (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    program_id BIGINT NOT NULL,
    hall_id BIGINT NOT NULL,
    from_date DATE,
    to_date DATE,
    start_time TIME,
    end_time TIME,
    CONSTRAINT fk_program_hall_program FOREIGN KEY (program_id) REFERENCES programs(id) ON DELETE CASCADE,
    CONSTRAINT fk_program_hall_hall FOREIGN KEY (hall_id) REFERENCES halls(id) ON DELETE RESTRICT
);
