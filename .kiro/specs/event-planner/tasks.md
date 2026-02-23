# Implementation Plan: Event Planner

## Overview

This implementation plan breaks down the Event Planner feature into discrete coding tasks. The system is a full-stack TypeScript/React application with a RESTful API backend and PostgreSQL database. Tasks are organized to build incrementally from database schema through backend API to frontend components, with property-based tests integrated throughout to validate correctness properties early.

## Tasks

- [x] 1. Set up project structure and database schema
  - Create project directories for frontend and backend
  - Initialize TypeScript configuration for both layers
  - Set up PostgreSQL database and connection pooling
  - Create database migration files for users, events, budget_items, and tasks tables with all constraints and indexes
  - Set up testing framework (Jest) and fast-check for property-based testing
  - _Requirements: 8.1, 8.2, 8.3_

- [x] 2. Implement authentication system
  - [x] 2.1 Create User model and database operations
    - Implement User interface and database queries (create, findByEmail, findById)
    - Add password hashing with bcrypt
    - _Requirements: 9.1, 9.3, 9.4_
  
  - [x] 2.2 Implement authentication middleware and endpoints
    - Create POST /api/auth/login endpoint with credential validation
    - Create POST /api/auth/logout endpoint
    - Create GET /api/auth/session endpoint for session verification
    - Implement JWT-based authentication middleware
    - _Requirements: 9.1, 9.2, 9.3, 9.4_
  
  - [ ]* 2.3 Write property tests for authentication
    - **Property 16: Authentication Required for Data Access**
    - **Property 17: Authentication Success and Failure**
    - **Validates: Requirements 9.1, 9.2, 9.3, 9.4**
  
  - [ ]* 2.4 Write unit tests for authentication edge cases
    - Test invalid token formats, expired tokens, missing credentials
    - _Requirements: 9.3, 9.4_

- [x] 3. Implement Event model and API endpoints
  - [x] 3.1 Create Event model and database operations
    - Implement Event interface and database queries (create, findByUserId, findById)
    - Add validation for title length, date, budget, description length, attendee count
    - _Requirements: 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 3.1_
  
  - [x] 3.2 Implement Event API endpoints with authorization
    - Create GET /api/events endpoint (returns user's events only)
    - Create POST /api/events endpoint with input validation
    - Create GET /api/events/:id endpoint with ownership verification
    - Add authorization checks to prevent cross-user access
    - _Requirements: 1.1, 2.1, 2.7, 2.8, 3.1, 3.2, 3.3_
  
  - [ ]* 3.3 Write property tests for Event validation
    - **Property 3: Text Field Length Validation** (event title, description)
    - **Property 4: Date Validation** (event date not in past)
    - **Property 5: Positive Number Validation** (budget, attendee count)
    - **Property 8: Required Field Validation** (event form)
    - **Validates: Requirements 2.2, 2.3, 2.4, 2.5, 2.6, 2.8, 10.1, 10.2, 10.3, 10.4, 10.5**
  
  - [ ]* 3.4 Write property tests for Event ownership and persistence
    - **Property 1: User Event Ownership and Isolation**
    - **Property 9: Data Persistence Round-Trip** (events)
    - **Property 10: User Data Retrieval Completeness**
    - **Validates: Requirements 1.1, 2.7, 3.1, 3.2, 3.3, 8.1, 8.4**

- [ ] 4. Checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 5. Implement BudgetItem model and API endpoints
  - [ ] 5.1 Create BudgetItem model and database operations
    - Implement BudgetItem interface and database queries (create, findByEventId)
    - Add validation for amount (positive decimal)
    - Implement budget calculation logic (total spent, remaining, percentage, overage)
    - _Requirements: 4.3, 4.4, 4.5, 5.1, 5.2, 5.3, 5.4_
  
  - [ ] 5.2 Implement BudgetItem API endpoints
    - Create GET /api/events/:eventId/budget-items endpoint
    - Create POST /api/events/:eventId/budget-items endpoint with validation
    - Add authorization to verify event ownership before budget operations
    - _Requirements: 4.1, 4.2, 4.4_
  
  - [ ]* 5.3 Write property tests for budget validation and calculations
    - **Property 5: Positive Number Validation** (budget item amount)
    - **Property 11: Budget Total Calculation**
    - **Property 12: Budget Comparison Calculation**
    - **Validates: Requirements 4.3, 4.5, 5.1, 5.2, 5.3, 5.4, 10.2**
  
  - [ ]* 5.4 Write property tests for budget item persistence
    - **Property 9: Data Persistence Round-Trip** (budget items)
    - **Property 18: Budget Item Display Completeness**
    - **Validates: Requirements 4.1, 4.4, 8.2**

- [ ] 6. Implement Task model and API endpoints
  - [ ] 6.1 Create Task model and database operations
    - Implement Task interface and database queries (create, findByEventId, with sorting and filtering)
    - Add validation for title length, description length, priority enum, progress range, date format
    - Implement sorting logic (by priority, by date)
    - Implement filtering logic (by progress status)
    - _Requirements: 6.2, 6.3, 6.4, 6.5, 6.6, 6.7, 6.8, 7.2, 7.3, 7.4_
  
  - [ ] 6.2 Implement Task API endpoints
    - Create GET /api/events/:eventId/tasks endpoint with query params for sorting and filtering
    - Create POST /api/events/:eventId/tasks endpoint with validation
    - Add authorization to verify event ownership before task operations
    - _Requirements: 6.1, 6.2, 6.8, 7.1_
  
  - [ ]* 6.3 Write property tests for task validation
    - **Property 3: Text Field Length Validation** (task title, description)
    - **Property 4: Date Validation** (task date)
    - **Property 6: Task Progress Range Validation**
    - **Property 7: Task Priority Enum Validation**
    - **Property 8: Required Field Validation** (task form)
    - **Validates: Requirements 6.3, 6.4, 6.5, 6.6, 6.7, 10.1, 10.3, 10.4, 10.5**
  
  - [ ]* 6.4 Write property tests for task operations
    - **Property 9: Data Persistence Round-Trip** (tasks)
    - **Property 14: Task Sorting Correctness**
    - **Property 15: Task Filtering Correctness**
    - **Property 19: Task Display Completeness for Event**
    - **Validates: Requirements 6.1, 6.8, 7.2, 7.3, 7.4, 8.3**

- [ ] 7. Checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 8. Implement frontend Dashboard component
  - [ ] 8.1 Create Dashboard component with event list display
    - Implement Dashboard component that fetches and displays user's events
    - Display event title, date, and attendee count for each event
    - Add "Create Event" button
    - Handle loading and error states
    - _Requirements: 1.1, 1.2, 1.3_
  
  - [ ]* 8.2 Write property tests for dashboard display
    - **Property 2: Event Display Completeness**
    - **Validates: Requirements 1.3**
  
  - [ ]* 8.3 Write unit tests for Dashboard component
    - Test create button presence, empty state, error handling
    - _Requirements: 1.2_

- [ ] 9. Implement frontend EventForm component
  - [ ] 9.1 Create EventForm component with validation
    - Implement form with fields for title, date, budget, description, attendee count
    - Add client-side validation for all fields (length, format, positive numbers, date not in past)
    - Display field-specific validation error messages
    - Disable submit button when validation errors exist
    - Handle form submission and API errors
    - _Requirements: 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.8, 10.1, 10.2, 10.3, 10.4, 10.5_
  
  - [ ]* 9.2 Write unit tests for EventForm validation
    - Test validation for each field type, error message display, form submission prevention
    - _Requirements: 2.8, 10.1, 10.5_

- [ ] 10. Implement frontend BudgetTracker component
  - [ ] 10.1 Create BudgetTracker component with budget item management
    - Implement component to display list of budget items
    - Add form to create new budget items (description, amount)
    - Calculate and display total spent
    - Calculate and display budget comparison (remaining/overage, percentage used)
    - Add visual indicators for over-budget status
    - Handle loading and error states
    - _Requirements: 4.1, 4.2, 4.5, 4.6, 5.1, 5.2, 5.3, 5.4_
  
  - [ ]* 10.2 Write property tests for budget display calculations
    - **Property 13: Task Display Completeness** (verify all attributes shown)
    - **Validates: Requirements 7.1**
  
  - [ ]* 10.3 Write unit tests for BudgetTracker component
    - Test budget item form, calculation display, over-budget indicators
    - _Requirements: 4.2, 4.6_

- [ ] 11. Implement frontend TaskManager component
  - [ ] 11.1 Create TaskManager component with task management
    - Implement component to display list of tasks with all attributes
    - Add form to create new tasks (title, description, priority, progress, date)
    - Add client-side validation for task fields
    - Implement sorting controls (by priority, by date)
    - Implement filtering controls (by progress status: incomplete, in-progress, complete)
    - Handle loading and error states
    - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5, 6.6, 6.7, 7.1, 7.2, 7.3, 7.4_
  
  - [ ]* 11.2 Write unit tests for TaskManager component
    - Test task form, sorting UI, filtering UI, task display
    - _Requirements: 6.2, 7.1, 7.2, 7.3, 7.4_

- [ ] 12. Implement routing and authentication flow
  - [ ] 12.1 Set up React Router and authentication context
    - Create routing structure (/, /login, /events/:id)
    - Implement authentication context provider
    - Add protected route wrapper that redirects unauthenticated users to login
    - Create login page component
    - _Requirements: 9.1, 9.2_
  
  - [ ]* 12.2 Write integration tests for authentication flow
    - Test redirect behavior, login success/failure, protected routes
    - _Requirements: 9.2, 9.3, 9.4_

- [ ] 13. Wire components together and implement event detail view
  - [ ] 13.1 Create EventDetail page component
    - Implement page that displays event information
    - Integrate BudgetTracker component
    - Integrate TaskManager component
    - Handle event loading and authorization errors
    - _Requirements: 3.3, 4.1, 6.1_
  
  - [ ] 13.2 Connect Dashboard to EventDetail navigation
    - Add click handlers to navigate from dashboard to event details
    - Ensure proper routing and state management
    - _Requirements: 1.1_
  
  - [ ]* 13.3 Write integration tests for complete user flows
    - Test event creation flow, budget tracking flow, task management flow
    - _Requirements: 2.7, 4.4, 6.8_

- [ ] 14. Final checkpoint - Ensure all tests pass
  - Run full test suite (unit, property-based, integration)
  - Verify all 19 correctness properties pass
  - Ensure all tests pass, ask the user if questions arise.

## Notes

- Tasks marked with `*` are optional and can be skipped for faster MVP
- Each task references specific requirements for traceability
- Property-based tests use fast-check with minimum 100 iterations
- All property tests are tagged with format: **Feature: event-planner, Property {number}: {property_text}**
- Backend uses TypeScript with Node.js/Express
- Frontend uses React with TypeScript
- Database is PostgreSQL with proper indexes and constraints
- Authentication uses JWT tokens
- All API endpoints require authentication except /api/auth/login
