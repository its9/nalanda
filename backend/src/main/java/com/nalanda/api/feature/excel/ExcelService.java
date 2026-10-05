package com.nalanda.api.feature.excel;

import java.nio.charset.StandardCharsets;
import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class ExcelService {

    private static final Map<String, String[]> TEMPLATE_HEADERS = new LinkedHashMap<>();

    static {
        TEMPLATE_HEADERS.put("employees", new String[] {"employeeId", "name", "department", "wing", "email", "phone"});
        TEMPLATE_HEADERS.put("programs", new String[] {"programId", "code", "name", "wing", "type", "status", "year"});
        TEMPLATE_HEADERS.put("nominations", new String[] {"nominationId", "programId", "employeeId", "status", "remarks"});
        TEMPLATE_HEADERS.put("attendance", new String[] {"programId", "employeeId", "date", "status", "hours"});
        TEMPLATE_HEADERS.put("reports", new String[] {"programId", "programName", "reportType", "generatedAt", "summary"});
    }

    public ExcelImportResponse importData(String source, MultipartFile file) {
        if (file == null || file.isEmpty()) {
            return new ExcelImportResponse(0, source, "No file uploaded");
        }
        return new ExcelImportResponse(1, source, "Excel file accepted for " + source);
    }

    public String importType(String source) {
        return source == null ? "unknown" : source.toLowerCase();
    }

    public byte[] template(String source) {
        String[] headers = TEMPLATE_HEADERS.getOrDefault(normalize(source), new String[] {"id", "name"});
        String csv = String.join(",", headers) + System.lineSeparator();
        return csv.getBytes(StandardCharsets.UTF_8);
    }

    public byte[] export(String source) {
        String[] headers = TEMPLATE_HEADERS.getOrDefault(normalize(source), new String[] {"id", "name"});
        String csv = String.join(",", headers) + System.lineSeparator();
        return csv.getBytes(StandardCharsets.UTF_8);
    }

    private String normalize(String source) {
        return source == null ? "employees" : source.toLowerCase();
    }
}
