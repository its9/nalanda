CREATE TABLE backup_history (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    backup_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    backup_path VARCHAR(500) NOT NULL,
    file_size BIGINT,
    created_by BIGINT,
    status VARCHAR(20) DEFAULT 'SUCCESS',
    remarks TEXT,
    CONSTRAINT fk_backup_user FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
);
