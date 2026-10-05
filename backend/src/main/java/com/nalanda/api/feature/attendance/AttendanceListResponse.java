package com.nalanda.api.feature.attendance;

import java.util.List;

public record AttendanceListResponse(List<AttendanceResponse> items, long total) {
}