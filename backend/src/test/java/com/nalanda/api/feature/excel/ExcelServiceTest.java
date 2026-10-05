package com.nalanda.api.feature.excel;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.Test;

class ExcelServiceTest {

    @Test
    void templateAndExportContainHeaders() {
        ExcelService service = new ExcelService();

        byte[] employeesTemplate = service.template("employees");
        byte[] reportExport = service.export("reports");

        assertTrue(new String(employeesTemplate).contains("employeeId"));
        assertTrue(new String(reportExport).contains("programId"));
        assertEquals("employees", service.importType("employees"));
    }
}
