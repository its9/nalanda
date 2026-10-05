package com.nalanda.api.feature.halls;

import java.time.LocalDate;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/halls")
public class HallsController {

    private final HallsService service;

    public HallsController(HallsService service) {
        this.service = service;
    }

    @GetMapping
    public HallListResponse list() {
        return service.list();
    }

    @GetMapping("/{id}")
    public HallResponse get(@PathVariable Long id) {
        return service.get(id);
    }

    @PostMapping
    public ResponseEntity<HallResponse> create(@Valid @RequestBody HallRequest request) {
        return ResponseEntity.status(201).body(service.create(request));
    }

    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<HallResponse> createWithPhoto(@RequestParam String name,
                                                         @RequestParam int capacity,
                                                         @RequestParam(required = false) String location,
    @RequestParam(required = false) String facilities,
    @RequestPart(required = false) MultipartFile photo) {
        return ResponseEntity.status(201).body(service.create(new HallRequest(name, capacity, location, facilities), photo));
    }

    @GetMapping("/{id}/photo")
    public ResponseEntity<byte[]> photo(@PathVariable Long id) {
        HallPhoto photo = service.photo(id);
        return ResponseEntity.ok().contentType(MediaType.parseMediaType(photo.contentType())).body(photo.data());
    }

    @PutMapping("/{id}")
    public HallResponse update(@PathVariable Long id, @Valid @RequestBody HallRequest request) {
        return service.update(id, request);
    }

    @PutMapping(value = "/{id}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public HallResponse updateWithPhoto(@PathVariable Long id,
                                        @RequestParam String name,
                                        @RequestParam int capacity,
                                        @RequestParam(required = false) String location,
                                        @RequestParam(required = false) String facilities,
                                        @RequestPart(required = false) MultipartFile photo) {
        return service.update(id, new HallRequest(name, capacity, location, facilities), photo);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/available")
    public HallListResponse available(@RequestParam LocalDate date) {
        return service.available(date);
    }

    @GetMapping("/{id}/bookings")
    public HallBookingListResponse bookings(@PathVariable Long id) {
        return service.bookings(id);
    }

    @PostMapping("/{id}/book")
    public HallBookingResponse book(@PathVariable Long id, @Valid @RequestBody HallBookingRequest request) {
        return service.book(id, request);
    }

    @PutMapping("/bookings/{id}")
    public HallBookingResponse updateBooking(@PathVariable Long id,
                                             @Valid @RequestBody HallBookingRequest request) {
        return service.updateBooking(id, request);
    }

    @DeleteMapping("/bookings/{id}")
    public ResponseEntity<Void> deleteBooking(@PathVariable Long id) {
        service.deleteBooking(id);
        return ResponseEntity.noContent().build();
    }
}