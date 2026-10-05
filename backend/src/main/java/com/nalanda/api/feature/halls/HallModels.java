package com.nalanda.api.feature.halls;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

import java.time.LocalDate;
import java.util.List;

record HallRequest(@NotBlank String name, @Positive int capacity, String location, String facilities) {
}

record HallResponse(Long id, String name, int capacity, String location, String facilities, String status, String photoUrl) {
}

record HallPhoto(byte[] data, String contentType) {
}

record HallListResponse(List<HallResponse> items, long total) {
}

record HallBookingRequest(@NotNull Long programId, @NotNull LocalDate date) {
}

record HallBookingResponse(Long id, Long hallId, Long programId, LocalDate date, String status) {
}

record HallBookingListResponse(List<HallBookingResponse> items, long total) {
}