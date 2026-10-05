package com.nalanda.api.feature.attendance;

public record AttendanceSummary(int nominated, int present, int absent, double attendancePercentage) {
}