package com.nalanda.api.feature.permissions;

import java.util.List;

record PermissionUpdateRequest(List<String> permissions) {
}

record PermissionListResponse(List<String> permissions, long total) {
}