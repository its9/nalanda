package com.nalanda.api.feature.calendar;

public record CalendarEvent(Long id, String type, String title, String date, String location) {
}