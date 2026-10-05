package com.nalanda.api.feature.calendar;

import java.util.List;
import java.util.Map;

record CalendarEntry(Long id, String type, String title, String date, String location) {
}