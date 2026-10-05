package com.nalanda.api.feature.reports;

import java.util.List;
import java.util.Map;

public record ReportResponse(String report, Map<String, Object> filters,
                             List<Map<String, Object>> rows, Map<String, Object> totals) {
}