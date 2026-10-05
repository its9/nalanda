CREATE TABLE halls (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    hall_name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100),
    capacity INT NOT NULL,
    facilities TEXT,
    photo_data LONGBLOB,
    photo_content_type VARCHAR(100),
    status VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE'
);
