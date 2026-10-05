package com.nalanda.api.feature.notifications;

import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;

import org.springframework.stereotype.Service;

import com.nalanda.api.common.ResourceNotFoundException;

@Service
public class NotificationsService {

    private final AtomicLong nextId = new AtomicLong(1);
    private final Map<Long, NotificationResponse> notifications = new ConcurrentHashMap<>();

    public NotificationListResponse list() {
        List<NotificationResponse> items = notifications.values().stream()
                .sorted((left, right) -> right.id().compareTo(left.id())).toList();
        long unread = items.stream().filter(notification -> !notification.read()).count();
        return new NotificationListResponse(items, items.size(), unread);
    }

    public NotificationResponse get(Long id) {
        NotificationResponse notification = notifications.get(id);
        if (notification == null) {
            throw new ResourceNotFoundException("Notification not found: " + id);
        }
        return notification;
    }

    public NotificationResponse create(NotificationRequest request) {
        Long id = nextId.getAndIncrement();
        NotificationResponse notification = new NotificationResponse(id, request.type(), request.title(),
                request.message(), request.userId(), request.relatedId(), false, Instant.now());
        notifications.put(id, notification);
        return notification;
    }

    public NotificationResponse markRead(Long id) {
        NotificationResponse current = get(id);
        NotificationResponse updated = new NotificationResponse(current.id(), current.type(), current.title(),
                current.message(), current.userId(), current.relatedId(), true, current.createdAt());
        notifications.put(id, updated);
        return updated;
    }

    public NotificationListResponse markAllRead() {
        notifications.replaceAll((id, notification) -> new NotificationResponse(notification.id(), notification.type(),
                notification.title(), notification.message(), notification.userId(), notification.relatedId(),
                true, notification.createdAt()));
        return list();
    }

    public void delete(Long id) {
        if (notifications.remove(id) == null) {
            throw new ResourceNotFoundException("Notification not found: " + id);
        }
    }
}