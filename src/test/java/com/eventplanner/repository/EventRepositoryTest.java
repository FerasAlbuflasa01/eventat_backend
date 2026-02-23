package com.eventplanner.repository;

import com.eventplanner.entity.Event;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.ActiveProfiles;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

@DataJpaTest
@ActiveProfiles("test")
public class EventRepositoryTest {
    
    @Autowired
    private EventRepository eventRepository;
    
    @Test
    public void testCreateAndFindEvent() {
        // Create test event
        UUID userId = UUID.randomUUID();
        Event event = new Event();
        event.setUserId(userId);
        event.setTitle("Test Event");
        event.setDate(LocalDate.now().plusDays(7));
        event.setBudget(new BigDecimal("1000.00"));
        event.setDescription("Test description");
        event.setAttendeeCount(50);
        
        // Save event
        Event savedEvent = eventRepository.save(event);
        
        // Verify saved
        assertNotNull(savedEvent.getId());
        assertEquals("Test Event", savedEvent.getTitle());
        assertEquals(userId, savedEvent.getUserId());
    }
    
    @Test
    public void testFindByUserId() {
        // Create test events for different users
        UUID userId1 = UUID.randomUUID();
        UUID userId2 = UUID.randomUUID();
        
        Event event1 = new Event();
        event1.setUserId(userId1);
        event1.setTitle("User 1 Event");
        event1.setDate(LocalDate.now().plusDays(7));
        event1.setBudget(new BigDecimal("1000.00"));
        event1.setDescription("Test");
        event1.setAttendeeCount(50);
        eventRepository.save(event1);
        
        Event event2 = new Event();
        event2.setUserId(userId2);
        event2.setTitle("User 2 Event");
        event2.setDate(LocalDate.now().plusDays(7));
        event2.setBudget(new BigDecimal("2000.00"));
        event2.setDescription("Test");
        event2.setAttendeeCount(100);
        eventRepository.save(event2);
        
        // Find events for user 1
        List<Event> user1Events = eventRepository.findByUserId(userId1);
        
        // Verify only user 1's events are returned
        assertEquals(1, user1Events.size());
        assertEquals("User 1 Event", user1Events.get(0).getTitle());
        assertEquals(userId1, user1Events.get(0).getUserId());
    }
    
    @Test
    public void testFindByIdAndUserId() {
        // Create test event
        UUID userId = UUID.randomUUID();
        Event event = new Event();
        event.setUserId(userId);
        event.setTitle("Test Event");
        event.setDate(LocalDate.now().plusDays(7));
        event.setBudget(new BigDecimal("1000.00"));
        event.setDescription("Test");
        event.setAttendeeCount(50);
        Event savedEvent = eventRepository.save(event);
        
        // Find by ID and correct user ID
        Optional<Event> found = eventRepository.findByIdAndUserId(savedEvent.getId(), userId);
        assertTrue(found.isPresent());
        assertEquals("Test Event", found.get().getTitle());
        
        // Try to find with wrong user ID
        UUID wrongUserId = UUID.randomUUID();
        Optional<Event> notFound = eventRepository.findByIdAndUserId(savedEvent.getId(), wrongUserId);
        assertFalse(notFound.isPresent());
    }
}
