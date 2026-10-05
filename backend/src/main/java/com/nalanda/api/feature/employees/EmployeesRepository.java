package com.nalanda.api.feature.employees;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import com.nalanda.api.common.ResourceNotFoundException;

@Repository
public class EmployeesRepository {

    private final JdbcTemplate jdbc;

    public EmployeesRepository(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public List<EmployeeResponse> list(String department, String unit) {
        StringBuilder sql = new StringBuilder(selectSql());
        List<Object> args = new ArrayList<>();
        if (department != null && !department.isBlank()) {
            sql.append(" WHERE LOWER(d.dept_code) = LOWER(?) OR LOWER(d.dept_name) = LOWER(?)");
            args.add(department);
            args.add(department);
        }
        if (unit != null && !unit.isBlank()) {
            sql.append(department != null && !department.isBlank() ? " AND " : " WHERE ");
            sql.append("(LOWER(u.unit_code) = LOWER(?) OR LOWER(u.unit_name) = LOWER(?))");
            args.add(unit);
            args.add(unit);
        }
        sql.append(" ORDER BY e.id");
        return jdbc.query(sql.toString(), this::map, args.toArray());
    }

    public Optional<EmployeeResponse> findById(Long id) {
        return jdbc.query(selectSql() + " WHERE e.id = ?", this::map, id).stream().findFirst();
    }

    public List<EmployeeResponse> search(String name, String employeeId) {
        StringBuilder sql = new StringBuilder(selectSql()).append(" WHERE 1 = 1");
        List<Object> args = new ArrayList<>();
        if (name != null && !name.isBlank()) {
            sql.append(" AND LOWER(e.name) LIKE LOWER(?)");
            args.add("%" + name + "%");
        }
        if (employeeId != null && !employeeId.isBlank()) {
            sql.append(" AND LOWER(e.employee_number) = LOWER(?)");
            args.add(employeeId);
        }
        sql.append(" ORDER BY e.id");
        return jdbc.query(sql.toString(), this::map, args.toArray());
    }

    public EmployeeOptionsResponse options() {
        List<EmployeeOption> units = jdbc.query(
                "SELECT unit_code, unit_name FROM units WHERE status = 'ACTIVE' ORDER BY unit_name",
                (result, row) -> new EmployeeOption(result.getString("unit_code"), result.getString("unit_name")));
        Map<String, List<EmployeeOption>> departments = new LinkedHashMap<>();
        jdbc.query("SELECT u.unit_code, d.dept_code, d.dept_name FROM departments d JOIN units u ON u.id = d.unit_id "
                + "WHERE d.status = 'ACTIVE' ORDER BY u.unit_name, d.dept_name",
            (result, row) -> new String[] { result.getString("unit_code"), result.getString("dept_code"), result.getString("dept_name") })
            .forEach(values -> departments.computeIfAbsent(values[0], key -> new ArrayList<>())
                .add(new EmployeeOption(values[1], values[2])));
        return new EmployeeOptionsResponse(units, departments);
    }

    public EmployeeResponse create(EmployeeRequest request) {
        Long departmentId = findDepartmentId(request.department());
        Long unitId = findUnitId(request.unit());
        validateUnit(departmentId, unitId);
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbc.update(connection -> {
            PreparedStatement statement = connection.prepareStatement(
                    "INSERT INTO employees (employee_number, employee_name, unit_id, department_id, designation, email, phone, internal_phone_number, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
                    new String[] { "id" });
            statement.setString(1, request.employeeId());
            statement.setString(2, request.name());
            statement.setLong(3, unitId);
            statement.setLong(4, departmentId);
            statement.setString(5, request.designation());
            statement.setString(6, request.email());
            statement.setString(7, request.phone());
            statement.setString(8, request.internalPhone());
            statement.setString(9, request.status() == null ? "ACTIVE" : request.status());
            return statement;
        }, keyHolder);
        return findById(keyHolder.getKey().longValue()).orElseThrow();
    }

    public EmployeeResponse update(Long id, EmployeeRequest request) {
        findById(id).orElseThrow();
        Long departmentId = findDepartmentId(request.department());
        Long unitId = findUnitId(request.unit());
        validateUnit(departmentId, unitId);
        jdbc.update("UPDATE employees SET employee_number = ?, employee_name = ?, unit_id = ?, department_id = ?, designation = ?, email = ?, phone = ?, internal_phone_number = ?, status = ? WHERE id = ?",
            request.employeeId(), request.name(), unitId, departmentId,
            request.designation(), request.email(), request.phone(), request.internalPhone(),
            request.status() == null ? "ACTIVE" : request.status(), id);
        return findById(id).orElseThrow();
    }

    public int delete(Long id) {
        jdbc.update("DELETE FROM test_results WHERE employee_id = ?", id);
        jdbc.update("DELETE FROM feedback WHERE employee_id = ?", id);
        jdbc.update("DELETE FROM attendance WHERE employee_id = ?", id);
        jdbc.update("DELETE FROM nominations WHERE employee_id = ?", id);
        return jdbc.update("DELETE FROM employees WHERE id = ?", id);
    }

    public byte[] export() {
        StringBuilder csv = new StringBuilder("employeeId,name,department,unit,email,phone,internalPhone,designation,joiningDate,status\n");
        list(null, null).forEach(employee -> csv.append(row(employee.employeeId(), employee.name(), employee.department(),
            employee.unit(), employee.email(), employee.phone(), employee.internalPhone(), employee.designation(),
                employee.joiningDate() == null ? "" : employee.joiningDate().toString(), employee.status())));
        return csv.toString().getBytes(java.nio.charset.StandardCharsets.UTF_8);
    }

    private Long findDepartmentId(String value) {
        return jdbc.query("SELECT id FROM departments WHERE LOWER(dept_code) = LOWER(?) OR LOWER(dept_name) = LOWER(?) LIMIT 1",
            (result, row) -> result.getLong("id"), value, value).stream().findFirst()
            .orElseThrow(() -> new ResourceNotFoundException("Department not found: " + value));
    }

    private Long findUnitId(String value) {
        return jdbc.query("SELECT id FROM units WHERE LOWER(unit_code) = LOWER(?) OR LOWER(unit_name) = LOWER(?) LIMIT 1",
            (result, row) -> result.getLong("id"), value, value).stream().findFirst()
            .orElseThrow(() -> new ResourceNotFoundException("Unit not found: " + value));
    }

    private void validateUnit(Long departmentId, Long unitId) {
        Integer matches = jdbc.queryForObject(
            "SELECT COUNT(*) FROM departments WHERE id = ? AND unit_id = ?",
            Integer.class, departmentId, unitId);
        if (matches == null || matches == 0) {
            throw new ResourceNotFoundException("Unit does not belong to department");
        }
    }

    private String selectSql() {
        return "SELECT e.id, e.employee_number AS employee_code, e.employee_name AS name, e.email, e.phone, e.internal_phone_number, e.designation, e.status, d.dept_code, d.dept_name, u.unit_code, u.unit_name FROM employees e JOIN departments d ON d.id = e.department_id JOIN units u ON u.id = e.unit_id";
    }

    private EmployeeResponse map(ResultSet result, int rowNumber) throws java.sql.SQLException {
        return new EmployeeResponse(result.getLong("id"), result.getString("employee_code"), result.getString("name"),
                result.getString("dept_name"), result.getString("unit_name"), result.getString("email"),
                result.getString("phone"), result.getString("internal_phone_number"), result.getString("designation"),
            null, result.getString("status"));
    }

    private String row(String... values) {
        return java.util.Arrays.stream(values).map(value -> value == null ? "" : value.replace(",", " "))
                .collect(java.util.stream.Collectors.joining(",")) + "\n";
    }
}
