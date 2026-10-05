package com.nalanda.api.dashboard;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/dashboard")
public class DashboardController {

    private final DashboardService dashboardService;

    public DashboardController(DashboardService dashboardService) {
        this.dashboardService = dashboardService;
    }

    @GetMapping("/summary")
    public DashboardSummary summary(@RequestParam(required = false) Integer year,
            @RequestParam(required = false) String wing) {
        return dashboardService.summary(year, wing);
    }

    @GetMapping("/programs")
    public ChartData programs() {
        return dashboardService.programs();
    }

    @GetMapping("/attendance")
    public ChartData attendance() {
        return dashboardService.attendance();
    }

    @GetMapping("/nominations")
    public ChartData nominations() {
        return dashboardService.nominations();
    }

    @GetMapping("/employees")
    public ChartData employees() {
        return dashboardService.employees();
    }

    @GetMapping("/faculty")
    public ChartData faculty() {
        return dashboardService.faculty();
    }

    @GetMapping("/halls")
    public ChartData halls() {
        return dashboardService.halls();
    }

    @GetMapping("/training-hours")
    public ChartData trainingHours() {
        return dashboardService.trainingHours();
    }

    @GetMapping("/mandays")
    public ChartData mandays() {
        return dashboardService.mandays();
    }

    @GetMapping("/monthly")
    public ChartData monthly() {
        return dashboardService.monthly();
    }

    @GetMapping("/yearly")
    public ChartData yearly() {
        return dashboardService.yearly();
    }

    public record DashboardSummary(int totalPrograms, int totalEmployees, int totalNominations,
            double averageAttendance, int totalMandays, int totalTrainingHours,
            Integer year, String wing) {

    }

    public record ChartData(java.util.List<String> labels, java.util.List<Number> values) {

    }
}
