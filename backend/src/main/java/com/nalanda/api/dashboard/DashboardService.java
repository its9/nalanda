package com.nalanda.api.dashboard;

import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class DashboardService {

    private final JdbcTemplate jdbc;

    public DashboardService(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public DashboardController.DashboardSummary summary(Integer year, String wing) {
        String programFilter = year == null ? "" : " WHERE YEAR(start_date) = " + year;
        int programs = count("SELECT COUNT(*) FROM programs" + programFilter);
        int employees = count("SELECT COUNT(*) FROM employees");
        int nominations = count("SELECT COUNT(*) FROM nominations");
        double attendance = number("SELECT COALESCE(100.0 * SUM(CASE WHEN UPPER(status) = 'PRESENT' THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0), 0) FROM attendance").doubleValue();
        int trainingHours = number("SELECT COALESCE(SUM(total_hours), 0) FROM programs" + programFilter).intValue();
        int mandays = number("SELECT COALESCE(SUM(num_days), 0) FROM programs" + programFilter).intValue();
        return new DashboardController.DashboardSummary(programs, employees, nominations, attendance, mandays, trainingHours, year, wing);
    }

    public DashboardController.ChartData programs() {
        return groupedStatuses("SELECT status, COUNT(*) FROM programs GROUP BY status", List.of("COMPLETED", "ONGOING", "PLANNED", "CANCELLED"));
    }

    public DashboardController.ChartData attendance() {
        return groupedStatuses("SELECT UPPER(status), COUNT(*) FROM attendance GROUP BY UPPER(status)", List.of("PRESENT", "ABSENT"));
    }

    public DashboardController.ChartData nominations() {
        return groupedStatuses("SELECT UPPER(status), COUNT(*) FROM nominations GROUP BY UPPER(status)", List.of("APPROVED", "PENDING", "REJECTED"));
    }

    public DashboardController.ChartData employees() {
        List<String> labels = jdbc.query("SELECT unit_name FROM units ORDER BY id", (result, row) -> result.getString(1));
        List<Number> values = jdbc.query("SELECT u.unit_name, COUNT(e.id) FROM units u LEFT JOIN employees e ON e.unit_id = u.id GROUP BY u.id, u.unit_name ORDER BY u.id",
                (result, row) -> result.getInt(2));
        return chart(labels, values);
    }

    public DashboardController.ChartData faculty() {
        return groupedStatuses("SELECT UPPER(faculty_type), COUNT(*) FROM faculty GROUP BY UPPER(faculty_type)", List.of("INTERNAL", "EXTERNAL"));
    }

    public DashboardController.ChartData halls() {
        return groupedStatuses("SELECT UPPER(status), COUNT(*) FROM halls GROUP BY UPPER(status)", List.of("AVAILABLE", "BOOKED"));
    }

    public DashboardController.ChartData trainingHours() {
        return monthlySum("total_hours");
    }

    public DashboardController.ChartData mandays() {
        return monthlySum("num_days");
    }

    public DashboardController.ChartData monthly() {
        return monthlySum("program_count");
    }

    public DashboardController.ChartData yearly() {
        List<String> labels = jdbc.query("SELECT DISTINCT YEAR(start_date) FROM programs WHERE start_date IS NOT NULL ORDER BY 1", (result, row) -> String.valueOf(result.getInt(1)));
        List<Number> values = jdbc.query("SELECT YEAR(start_date), COUNT(*) FROM programs WHERE start_date IS NOT NULL GROUP BY YEAR(start_date) ORDER BY 1", (result, row) -> result.getInt(2));
        return chart(labels, values);
    }

    private DashboardController.ChartData monthlySum(String column) {
        if (column.equals("program_count")) {
            return chart(List.of(), List.<Number>of());
        }
        List<String> labels = jdbc.query("SELECT DATE_FORMAT(start_date, '%b') FROM programs WHERE start_date IS NOT NULL GROUP BY MONTH(start_date), DATE_FORMAT(start_date, '%b') ORDER BY MONTH(start_date)", (result, row) -> result.getString(1));
        List<Number> values = jdbc.query("SELECT DATE_FORMAT(start_date, '%b'), COALESCE(SUM(" + column + "), 0) FROM programs WHERE start_date IS NOT NULL GROUP BY MONTH(start_date), DATE_FORMAT(start_date, '%b') ORDER BY MONTH(start_date)", (result, row) -> result.getBigDecimal(2));
        return chart(labels, values);
    }

    private DashboardController.ChartData groupedStatuses(String sql, List<String> labels) {
        var counts = jdbc.query(sql, (result, row) -> new Object[] { result.getString(1), result.getLong(2) });
        List<Number> values = labels.stream().map(label -> counts.stream().filter(item -> label.equalsIgnoreCase(String.valueOf(item[0]))).map(item -> (Number) item[1]).findFirst().orElse(0L)).toList();
        return chart(labels, values);
    }

    private int count(String sql) { return number(sql).intValue(); }
    private Number number(String sql) { return jdbc.queryForObject(sql, Number.class); }
    private DashboardController.ChartData chart(List<String> labels, List<Number> values) { return new DashboardController.ChartData(labels, values); }
}
