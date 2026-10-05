CREATE TABLE faculty (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    faculty_name VARCHAR(100) NOT NULL,
    designation VARCHAR(100),
    organization VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    photo_data MEDIUMBLOB,
    photo_content_type VARCHAR(100),
    faculty_type VARCHAR(20) DEFAULT 'INTERNAL',
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
