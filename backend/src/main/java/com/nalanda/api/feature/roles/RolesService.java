package com.nalanda.api.feature.roles;

import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import jakarta.annotation.PostConstruct;

import com.nalanda.api.common.ResourceNotFoundException;

@Service
public class RolesService {

    private final JdbcTemplate jdbc;

    public RolesService(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    @PostConstruct
    void ensureDefaultRoles() {
        if (jdbc.queryForObject("SELECT COUNT(*) FROM roles", Integer.class) == 0) {
            create(new RoleRequest("ADMIN", "Administrator", "Full system access"));
            create(new RoleRequest("PROGRAM_COORDINATOR", "Program Coordinator", "Program management access"));
            create(new RoleRequest("FACULTY", "Faculty", "Faculty access"));
            create(new RoleRequest("HALL_MANAGER", "Hall Manager", "Hall booking access"));
            create(new RoleRequest("EMPLOYEE", "Employee", "Employee access"));
            create(new RoleRequest("VIEWER", "Viewer", "Read-only access"));
        }
    }

    public RoleListResponse list() {
        List<RoleResponse> items = jdbc.query("SELECT id, role_name, role_name, description FROM roles ORDER BY id",
            (result, row) -> new RoleResponse(result.getLong("id"), result.getString("role_name"),
                result.getString("role_name"), result.getString("description")));
        return new RoleListResponse(items, items.size());
    }

    public RoleResponse get(Long id) {
        return list().items().stream().filter(role -> role.id().equals(id)).findFirst()
            .orElseThrow(() -> new ResourceNotFoundException("Role not found: " + id));
    }

    public RoleResponse create(RoleRequest request) {
        jdbc.update("INSERT INTO roles (role_name, description, status) VALUES (?, ?, 'ACTIVE')",
            request.code(), request.description());
        Long id = jdbc.queryForObject("SELECT id FROM roles WHERE role_name = ?", Long.class, request.code());
        return get(id);
    }

    public RoleResponse update(Long id, RoleRequest request) {
        get(id);
        jdbc.update("UPDATE roles SET role_name = ?, description = ? WHERE id = ?",
            request.code(), request.description(), id);
        return get(id);
    }

    public void delete(Long id) {
        get(id);
        jdbc.update("DELETE FROM roles WHERE id = ?", id);
    }
}