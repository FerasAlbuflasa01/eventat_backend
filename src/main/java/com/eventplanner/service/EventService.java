package com.eventplanner.service;

import com.eventplanner.entity.Event;
import com.eventplanner.repository.EventRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class EventService {
    
    @Autowired
    private EventRepository eventRepository;
    
    public Event createEvent(Event event) {
        return eventRepository.save(event);
    }
    
    public List<Event> getEventsByUserId(UUID userId) {
        return eventRepository.findByUserId(userId);
    }
    
    public Optional<Event> getEventById(UUID eventId, UUID userId) {
        return eventRepository.findByIdAndUserId(eventId, userId);
    }
}
