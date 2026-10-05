package com.nalanda.api.common;

import java.util.List;

public record ModuleResponse(String module, List<Object> items) {
}