package com.nalanda.api.feature.permissions;

import java.util.List;

public record PermissionResponse(Long roleId, String role, List<String> permissions) {
}