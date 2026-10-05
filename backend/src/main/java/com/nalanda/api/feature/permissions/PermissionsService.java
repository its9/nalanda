package com.nalanda.api.feature.permissions;

import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class PermissionsService {

    private static final List<String> CATALOG = List.of(
        "DASHBOARD_VIEW", "USER_VIEW", "USER_CREATE", "USER_EDIT", "USER_DELETE",
        "ROLE_MANAGE", "PROGRAM_VIEW", "PROGRAM_CREATE", "PROGRAM_EDIT", "PROGRAM_DELETE",
        "NOMINATION_MANAGE", "ATTENDANCE_MANAGE", "REPORT_VIEW", "SETTINGS_MANAGE"
    );
    private final JdbcTemplate jdbc;

    public PermissionsService(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
        jdbc.execute("""
            CREATE TABLE IF NOT EXISTS role_permissions (
                role_id BIGINT NOT NULL,
                permission_code VARCHAR(100) NOT NULL,
                PRIMARY KEY (role_id, permission_code),
                CONSTRAINT fk_role_permissions_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
            )
            """);
    }

    public PermissionListResponse list() {
        return new PermissionListResponse(CATALOG, CATALOG.size());
    }

    public PermissionResponse get(Long roleId) {
        String role = jdbc.queryForObject("SELECT role_name FROM roles WHERE id = ?", String.class, roleId);
        List<String> values = jdbc.query("SELECT permission_code FROM role_permissions WHERE role_id = ? ORDER BY permission_code",
            (result, row) -> result.getString("permission_code"), roleId);
        return new PermissionResponse(roleId, role, values);
    }

    public PermissionResponse update(Long roleId, PermissionUpdateRequest request) {
        get(roleId);
        jdbc.update("DELETE FROM role_permissions WHERE role_id = ?", roleId);
        request.permissions().stream().filter(CATALOG::contains).distinct().forEach(permission ->
            jdbc.update("INSERT INTO role_permissions (role_id, permission_code) VALUES (?, ?)", roleId, permission));
        return get(roleId);
    }
}