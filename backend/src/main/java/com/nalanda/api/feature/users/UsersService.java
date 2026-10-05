package com.nalanda.api.feature.users;

import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import com.nalanda.api.common.ResourceNotFoundException;

@Service
public class UsersService {

    private final JdbcTemplate jdbc;

    public UsersService(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public UserListResponse list() {
        List<UserResponse> items = jdbc.query("""
            SELECT u.id, u.username, u.email, COALESCE(e.employee_name, u.username) AS name,
                   COALESCE(r.role_name, 'VIEWER') AS role, u.status
            FROM users u
            LEFT JOIN employees e ON e.id = u.employee_id
            LEFT JOIN user_roles ur ON ur.user_id = u.id
            LEFT JOIN roles r ON r.id = ur.role_id
            ORDER BY u.id
            """, (result, row) -> new UserResponse(result.getLong("id"), result.getString("username"),
                result.getString("email"), result.getString("name"), result.getString("role"),
                "ACTIVE".equalsIgnoreCase(result.getString("status"))));
        return new UserListResponse(items, items.size());
    }

    public byte[] exportCsv() {
        StringBuilder csv = new StringBuilder("id,name,username,email,role,status\n");
        list().items().forEach(user -> csv.append(user.id()).append(',')
            .append(csvValue(user.name())).append(',')
            .append(csvValue(user.username())).append(',')
            .append(csvValue(user.email())).append(',')
            .append(csvValue(user.role())).append(',')
            .append(user.active() ? "ACTIVE" : "INACTIVE").append('\n'));
        return csv.toString().getBytes(java.nio.charset.StandardCharsets.UTF_8);
    }

    private String csvValue(String value) {
        if (value == null) return "";
        return "\"" + value.replace("\"", "\"\"") + "\"";
    }

    public UserResponse get(Long id) {
        return list().items().stream().filter(user -> user.id().equals(id)).findFirst()
            .orElseThrow(() -> new ResourceNotFoundException("System user not found: " + id));
    }

    public UserResponse create(UserRequest request) {
        Long employeeId = employeeId(request);
        Long roleId = roleId(request.role());
        jdbc.update("INSERT INTO users (username, password, employee_id, email, status) VALUES (?, ?, ?, ?, 'ACTIVE')",
            request.username(), java.util.UUID.randomUUID().toString(), employeeId, request.email());
        Long userId = jdbc.queryForObject("SELECT id FROM users WHERE username = ?", Long.class, request.username());
        jdbc.update("INSERT INTO user_roles (user_id, role_id) VALUES (?, ?)", userId, roleId);
        return get(userId);
    }

    public UserResponse update(Long id, UserRequest request) {
        UserResponse current = get(id);
        jdbc.update("UPDATE users SET username = ?, email = ?, employee_id = ? WHERE id = ?",
            request.username(), request.email(), employeeId(request), id);
        updateRole(id, request.role());
        return getWithActive(id, current.active());
    }

    public void delete(Long id) {
        get(id);
        jdbc.update("DELETE FROM users WHERE id = ?", id);
    }

    public UserActionResponse activate(Long id, boolean active) {
        UserResponse current = get(id);
        jdbc.update("UPDATE users SET status = ? WHERE id = ?", active ? "ACTIVE" : "INACTIVE", id);
        return new UserActionResponse(id, active ? "User activated" : "User deactivated", active, current.role());
    }

    public UserActionResponse resetPassword(Long id) {
        UserResponse user = get(id);
        jdbc.update("UPDATE users SET password = ? WHERE id = ?", java.util.UUID.randomUUID().toString(), id);
        return new UserActionResponse(id, "Password reset successfully", user.active(), user.role());
    }

    public UserActionResponse updateRole(Long id, String role) {
        UserResponse current = get(id);
        jdbc.update("DELETE FROM user_roles WHERE user_id = ?", id);
        jdbc.update("INSERT INTO user_roles (user_id, role_id) VALUES (?, ?)", id, roleId(role));
        return new UserActionResponse(id, "Role updated", current.active(), role);
    }

    private UserResponse getWithActive(Long id, boolean active) {
        UserResponse user = get(id);
        return new UserResponse(user.id(), user.username(), user.email(), user.name(), user.role(), active);
    }

    private Long employeeId(UserRequest request) {
        if (request.employeeId() != null) return request.employeeId();
        return jdbc.query("SELECT id FROM employees WHERE LOWER(employee_name) = LOWER(?) OR LOWER(email) = LOWER(?) LIMIT 1",
            (result, row) -> result.getLong("id"), request.name(), request.email()).stream().findFirst().orElse(null);
    }

    private Long roleId(String role) {
        return jdbc.query("SELECT id FROM roles WHERE UPPER(role_name) = UPPER(?) LIMIT 1",
            (result, row) -> result.getLong("id"), role).stream().findFirst()
            .orElseThrow(() -> new ResourceNotFoundException("Role not found: " + role));
    }
}