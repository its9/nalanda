package com.nalanda.api.feature.reports;

import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.nalanda.api.feature.attendance.AttendanceService;
import com.nalanda.api.feature.employees.EmployeesService;
import com.nalanda.api.feature.faculty.FacultyService;
import com.nalanda.api.feature.halls.HallsService;
import com.nalanda.api.feature.nominations.NominationsService;
import com.nalanda.api.feature.programs.ProgramsService;

@Service
public class ReportsService {

    private final ProgramsService programs;
    private final AttendanceService attendance;
    private final NominationsService nominations;
    private final EmployeesService employees;
    private final FacultyService faculty;
    private final HallsService halls;

    public ReportsService(ProgramsService programs, AttendanceService attendance, NominationsService nominations,
                          EmployeesService employees, FacultyService faculty, HallsService halls) {
        this.programs = programs;
        this.attendance = attendance;
        this.nominations = nominations;
        this.employees = employees;
        this.faculty = faculty;
        this.halls = halls;
    }

    public ReportResponse report(String type, Integer year, Integer month) {
        Map<String, Object> filters = Map.of("year", year == null ? "" : year, "month", month == null ? "" : month);
        return new ReportResponse(type, filters, List.of(), totals());
    }

    public ReportResponse program(Long id) {
        return new ReportResponse("program", Map.of("programId", id),
            List.of(programs.reportData(id)), Map.of());
    }

    public byte[] export(String type, Integer year, Integer month) {
        ReportResponse report = report(type, year, month);
        String csv = "report,year,month,totalPrograms,totalEmployees,totalNominations\n"
                + report.report() + "," + yearOrBlank(year) + "," + yearOrBlank(month) + ","
                + report.totals().get("totalPrograms") + "," + report.totals().get("totalEmployees") + ","
                + report.totals().get("totalNominations") + "\n";
        return csv.getBytes(StandardCharsets.UTF_8);
    }

    private Map<String, Object> totals() {
        return Map.of(
                "totalPrograms", programs.reportCount(),
                "totalEmployees", employees.reportCount(),
                "totalNominations", nominations.reportCount(),
                "totalAttendanceRecords", attendance.reportCount(),
                "totalFaculty", faculty.reportCount(),
                "totalHalls", halls.reportCount());
    }

    private String yearOrBlank(Integer value) {
        return value == null ? "" : value.toString();
    }
}