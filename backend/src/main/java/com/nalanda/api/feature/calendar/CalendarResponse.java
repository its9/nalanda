package com.nalanda.api.feature.calendar;

import java.util.List;
import java.util.Map;

public record CalendarResponse(Map<String, String> filters, List<CalendarEvent> events, long total) {
}