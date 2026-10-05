package com.nalanda.api.feature.settings;

import java.util.Map;

public record SettingsResponse(String scope, Map<String, Object> values) {
}