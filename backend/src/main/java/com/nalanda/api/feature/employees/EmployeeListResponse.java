package com.nalanda.api.feature.employees;

import java.util.List;

public record EmployeeListResponse(List<EmployeeResponse> items, long total) {
}