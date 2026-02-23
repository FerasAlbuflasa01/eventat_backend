package com.eventplanner.dto;

import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CreateEventRequest {
    
    @NotBlank(message = "Title is required")
    @Size(max = 200, message = "Title must not exceed 200 characters")
    private String title;
    
    @NotNull(message = "Date is required")
    private LocalDate date;
    
    @NotNull(message = "Budget is required")
    @DecimalMin(value = "0.01", message = "Budget must be positive")
    private BigDecimal budget;
    
    @Size(max = 2000, message = "Description must not exceed 2000 characters")
    private String description;
    
    @NotNull(message = "Attendee count is required")
    @Min(value = 1, message = "Attendee count must be at least 1")
    private Integer attendeeCount;
}
