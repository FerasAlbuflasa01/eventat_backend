package com.eventplanner.dto;

import com.eventplanner.entity.Event;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EventResponse {
    
    private UUID id;
    private UUID userId;
    private String title;
    private LocalDate date;
    private BigDecimal budget;
    private String description;
    private Integer attendeeCount;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    public static EventResponse fromEntity(Event event) {
        return new EventResponse(
            event.getId(),
            event.getUserId(),
            event.getTitle(),
            event.getDate(),
            event.getBudget(),
            event.getDescription(),
            event.getAttendeeCount(),
            event.getCreatedAt(),
            event.getUpdatedAt()
        );
    }
}
