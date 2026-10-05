package com.nalanda.api.feature.audit;

import java.util.List;

import org.springframework.stereotype.Service;

import com.nalanda.api.common.ModuleResponse;

@Service
public class AuditService {

    public ModuleResponse list() {
        return new ModuleResponse("audit", List.of());
    }
}