-- Create a test user for development/testing
-- Email: test@example.com
-- Password: password123
-- Password hash generated with BCrypt (strength 10)

INSERT INTO users (id, email, password_hash, created_at, updated_at)
VALUES (
    gen_random_uuid(),
    'test@example.com',
    '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
)
ON CONFLICT (email) DO NOTHING;

-- Verify the user was created
SELECT id, email, created_at FROM users WHERE email = 'test@example.com';
