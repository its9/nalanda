-- Apply manually to existing installations because schema initialization is disabled.
ALTER TABLE faculty ADD COLUMN photo_data MEDIUMBLOB;
ALTER TABLE faculty ADD COLUMN photo_content_type VARCHAR(100);
