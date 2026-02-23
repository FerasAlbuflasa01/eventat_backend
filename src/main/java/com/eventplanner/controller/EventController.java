package com.eventplanner.controller;

import com.eventplanner.dto.CreateEventRequest;
import com.eventplanner.dto.EventResponse;
import com.eventplanner.entity.Event;
import com.eventplanner.service.EventService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/events")
public class EventController {
    
    @Autowired
    private EventService eventService;
    
    private UUID getAuthenticatedUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            throw new RuntimeException("Not authenticated");
        }
        return (UUID) authentication.getPrincipal();
    }
    
    @GetMapping
    public ResponseEntity<?> getEvents() {
        try {
            UUID userId = getAuthenticatedUserId();
            List<Event> events = eventService.getEventsByUserId(userId);
            List<EventResponse> response = events.stream()
                    .map(EventResponse::fromEntity)
                    .collect(Collectors.toList());
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error);
        }
    }
    
    @PostMapping
    public ResponseEntity<?> createEvent(@Valid @RequestBody CreateEventRequest request) {
        try {
            UUID userId = getAuthenticatedUserId();
            
            // Validate date is not in the past
            if (request.getDate().isBefore(LocalDate.now())) {
                Map<String, Object> error = new HashMap<>();
                error.put("error", "Validation failed");
                Map<String, String> validationError = new HashMap<>();
                validationError.put("field", "date");
                validationError.put("message", "Date must not be in the past");
                error.put("validationErrors", List.of(validationError));
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
            }
            
            Event event = new Event();
            event.setUserId(userId);
            event.setTitle(request.getTitle());
            event.setDate(request.getDate());
            event.setBudget(request.getBudget());
            event.setDescription(request.getDescription());
            event.setAttendeeCount(request.getAttendeeCount());
            
            Event savedEvent = eventService.createEvent(event);
            EventResponse response = EventResponse.fromEntity(savedEvent);
            
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (RuntimeException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error);
        }
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<?> getEventById(@PathVariable UUID id) {
        try {
            UUID userId = getAuthenticatedUserId();
            Event event = eventService.getEventById(id, userId)
                    .orElseThrow(() -> new RuntimeException("Event not found or access denied"));
            
            EventResponse response = EventResponse.fromEntity(event);
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", e.getMessage());
            
            if (e.getMessage().equals("Not authenticated")) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error);
            }
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
        }
    }
}
