package com.nalanda.api.feature.wings;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;

import org.springframework.stereotype.Service;

import com.nalanda.api.common.ResourceNotFoundException;

@Service
public class WingsService {

    private final AtomicLong nextId = new AtomicLong(1);
    private final Map<Long, WingResponse> wings = new ConcurrentHashMap<>();

    public WingListResponse list() {
        List<WingResponse> items = wings.values().stream()
                .sorted((left, right) -> left.id().compareTo(right.id()))
                .toList();
        return new WingListResponse(items, items.size());
    }

    public WingResponse get(Long id) {
        WingResponse wing = wings.get(id);
        if (wing == null) {
            throw new ResourceNotFoundException("Wing not found: " + id);
        }
        return wing;
    }

    public WingResponse create(WingRequest request) {
        Long id = nextId.getAndIncrement();
        WingResponse wing = toResponse(id, request);
        wings.put(id, wing);
        return wing;
    }

    public WingResponse update(Long id, WingRequest request) {
        get(id);
        WingResponse wing = toResponse(id, request);
        wings.put(id, wing);
        return wing;
    }

    public void delete(Long id) {
        if (wings.remove(id) == null) {
            throw new ResourceNotFoundException("Wing not found: " + id);
        }
    }

    private WingResponse toResponse(Long id, WingRequest request) {
        return new WingResponse(id, request.code(), request.name(), request.description());
    }
}