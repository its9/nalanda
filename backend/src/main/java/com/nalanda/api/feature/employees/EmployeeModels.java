package com.nalanda.api.feature.employees;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

import java.util.List;
import java.util.Map;
import java.time.LocalDate;

record EmployeeRequest(
        @NotBlank String employeeId,
        @NotBlank String name,
        @NotBlank String department,
        @NotBlank String unit,
        @Email String email,
        String phone,
        String internalPhone,
        String designation,
        LocalDate joiningDate,
        String status) {
}

record EmployeeResponse(
        Long id,
        String employeeId,
        String name,
        String department,
        String unit,
        String email,
        String phone,
        String internalPhone,
        String designation,
        LocalDate joiningDate,
        String status) {
}

record EmployeeImportResponse(int imported, String message) {
}

record EmployeeOption(String code, String name) {
}

record EmployeeOptionsResponse(List<EmployeeOption> units, Map<String, List<EmployeeOption>> departments) {
}