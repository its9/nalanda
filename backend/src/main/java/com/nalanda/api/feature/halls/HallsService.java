package com.nalanda.api.feature.halls;

import java.time.LocalDate;
import java.util.List;
import java.util.concurrent.atomic.AtomicLong;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.nalanda.api.common.ConflictException;
import com.nalanda.api.common.ResourceNotFoundException;

@Service
public class HallsService {

    private final AtomicLong nextHallId = new AtomicLong(1);
    private final AtomicLong nextBookingId = new AtomicLong(1);
    private final java.util.Map<Long, HallBookingResponse> bookings = new java.util.concurrent.ConcurrentHashMap<>();
    private final HallsRepository repository;

    public HallsService(HallsRepository repository) {
        this.repository = repository;
    }

    public HallListResponse list() {
        List<HallResponse> items = repository.list();
        return new HallListResponse(items, items.size());
    }

    public long reportCount() {
        return repository.list().size();
    }

    public HallResponse get(Long id) {
        return repository.findById(id).orElseThrow(() -> new ResourceNotFoundException("Hall not found: " + id));
    }

    public HallResponse create(HallRequest request) {
        return repository.create(request, null, null);
    }

    public HallResponse create(HallRequest request, MultipartFile photo) {
        try {
            return repository.create(request, photo == null || photo.isEmpty() ? null : photo.getBytes(),
                    photo == null || photo.isEmpty() ? null : photo.getContentType());
        } catch (java.io.IOException exception) {
            throw new IllegalArgumentException("Hall photo could not be read", exception);
        }
    }

    public HallPhoto photo(Long id) {
        get(id);
        return repository.photo(id).orElseThrow(() -> new ResourceNotFoundException("Hall photo not found: " + id));
    }

    public HallResponse update(Long id, HallRequest request) {
        get(id);
        return repository.update(id, request);
    }

    public HallResponse update(Long id, HallRequest request, MultipartFile photo) {
        get(id);
        try {
            return photo == null || photo.isEmpty()
                    ? repository.update(id, request)
                    : updatePhoto(id, request, photo.getBytes(), photo.getContentType());
        } catch (java.io.IOException exception) {
            throw new IllegalArgumentException("Hall photo could not be read", exception);
        }
    }

    private HallResponse updatePhoto(Long id, HallRequest request, byte[] photoData, String contentType) {
        repository.update(id, request);
        return repository.updatePhoto(id, photoData, contentType);
    }

    public void delete(Long id) {
        get(id);
        repository.delete(id);
        bookings.values().removeIf(booking -> booking.hallId().equals(id));
    }

    public HallListResponse available(LocalDate date) {
        List<Long> bookedHallIds = bookings.values().stream()
                .filter(booking -> booking.date().equals(date))
                .map(HallBookingResponse::hallId).toList();
        List<HallResponse> items = repository.list().stream()
                .filter(hall -> !bookedHallIds.contains(hall.id()))
                .sorted((left, right) -> left.id().compareTo(right.id())).toList();
        return new HallListResponse(items, items.size());
    }

    public HallBookingListResponse bookings(Long hallId) {
        get(hallId);
        List<HallBookingResponse> items = bookings.values().stream()
                .filter(booking -> booking.hallId().equals(hallId))
                .sorted((left, right) -> left.id().compareTo(right.id())).toList();
        return new HallBookingListResponse(items, items.size());
    }

    public HallBookingResponse book(Long hallId, HallBookingRequest request) {
        get(hallId);
        boolean occupied = bookings.values().stream()
                .anyMatch(booking -> booking.hallId().equals(hallId) && booking.date().equals(request.date()));
        if (occupied) {
            throw new ConflictException("Hall is already booked for " + request.date());
        }
        Long id = nextBookingId.getAndIncrement();
        HallBookingResponse booking = new HallBookingResponse(id, hallId, request.programId(), request.date(), "BOOKED");
        bookings.put(id, booking);
        return booking;
    }

    public HallBookingResponse updateBooking(Long id, HallBookingRequest request) {
        HallBookingResponse current = getBooking(id);
        boolean occupied = bookings.values().stream()
                .anyMatch(booking -> !booking.id().equals(id) && booking.hallId().equals(current.hallId())
                        && booking.date().equals(request.date()));
        if (occupied) {
            throw new ConflictException("Hall is already booked for " + request.date());
        }
        HallBookingResponse updated = new HallBookingResponse(id, current.hallId(), request.programId(),
                request.date(), current.status());
        bookings.put(id, updated);
        return updated;
    }

    public void deleteBooking(Long id) {
        getBooking(id);
        bookings.remove(id);
    }

    private HallBookingResponse getBooking(Long id) {
        HallBookingResponse booking = bookings.get(id);
        if (booking == null) {
            throw new ResourceNotFoundException("Hall booking not found: " + id);
        }
        return booking;
    }
}