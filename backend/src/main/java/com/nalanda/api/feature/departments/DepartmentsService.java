package com.nalanda.api.feature.departments;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;

import org.springframework.stereotype.Service;

import com.nalanda.api.common.ResourceNotFoundException;
import com.nalanda.api.feature.employees.EmployeeListResponse;
import com.nalanda.api.feature.employees.EmployeesService;

@Service
public class DepartmentsService {

    private final AtomicLong nextId = new AtomicLong(1);
    private final Map<Long, DepartmentResponse> departments = new ConcurrentHashMap<>();
    private final EmployeesService employeesService;

    public DepartmentsService(EmployeesService employeesService) {
        this.employeesService = employeesService;
    }

    public DepartmentListResponse list() {
        List<DepartmentResponse> items = departments.values().stream()
                .sorted((left, right) -> left.id().compareTo(right.id()))
                .toList();
        return new DepartmentListResponse(items, items.size());
    }

    public DepartmentResponse get(Long id) {
        DepartmentResponse department = departments.get(id);
        if (department == null) {
            throw new ResourceNotFoundException("Department not found: " + id);
        }
        return department;
    }

    public DepartmentResponse create(DepartmentRequest request) {
        Long id = nextId.getAndIncrement();
        DepartmentResponse department = toResponse(id, request);
        departments.put(id, department);
        return department;
    }

    public DepartmentResponse update(Long id, DepartmentRequest request) {
        get(id);
        DepartmentResponse department = toResponse(id, request);
        departments.put(id, department);
        return department;
    }

    public void delete(Long id) {
        if (departments.remove(id) == null) {
            throw new ResourceNotFoundException("Department not found: " + id);
        }
    }

    public EmployeeListResponse employees(Long id) {
        DepartmentResponse department = get(id);
        return employeesService.list(department.code(), null);
    }

    private DepartmentResponse toResponse(Long id, DepartmentRequest request) {
        return new DepartmentResponse(id, request.code(), request.name(), request.description());
    }
}