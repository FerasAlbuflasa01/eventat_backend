// Jest setup file for backend tests
// This file runs before all tests

// Set test environment variables
process.env.NODE_ENV = 'test';
process.env.DATABASE_URL = process.env.DATABASE_URL || 'postgresql://test:test@localhost:5432/event_planner_test';
process.env.JWT_SECRET = 'test-secret-key';
