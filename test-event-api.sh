#!/bin/bash

BASE_URL="http://localhost:8080"

echo "========================================="
echo "Event API Test Script"
echo "========================================="
echo ""
echo "Base URL: $BASE_URL"
echo ""

# First, login to get a token
echo "Step 1: Logging in to get authentication token..."
LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/api/auth/login" \
    -H "Content-Type: application/json" \
    -d '{"email":"test@example.com","password":"password123"}')

TOKEN=$(echo $LOGIN_RESPONSE | grep -o '"token":"[^"]*' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
    echo "❌ FAIL: Could not obtain authentication token"
    echo "Response: $LOGIN_RESPONSE"
    echo ""
    echo "Make sure:"
    echo "1. The server is running (./start.sh)"
    echo "2. The database is set up"
    echo "3. Test user exists (psql -U postgres -d eventplanner -f create-test-user.sql)"
    exit 1
fi

echo "✅ Successfully obtained token"
echo ""

# Test 1: Get events (should be empty initially)
echo "Test 1: Getting all events for authenticated user..."
RESPONSE=$(curl -s -w "\n%{http_code}" "$BASE_URL/api/events" \
    -H "Authorization: Bearer $TOKEN")
HTTP_CODE=$(echo "$RESPONSE" | tail -n 1)
BODY=$(echo "$RESPONSE" | head -n -1)

if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ PASS: GET /api/events returns 200"
    echo "Response: $BODY"
else
    echo "❌ FAIL: Expected 200, got $HTTP_CODE"
fi
echo ""

# Test 2: Create an event
echo "Test 2: Creating a new event..."
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/api/events" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
        "title": "Test Conference",
        "date": "2025-12-31",
        "budget": 5000.00,
        "description": "Annual company conference",
        "attendeeCount": 100
    }')
HTTP_CODE=$(echo "$RESPONSE" | tail -n 1)
BODY=$(echo "$RESPONSE" | head -n -1)

if [ "$HTTP_CODE" = "201" ]; then
    echo "✅ PASS: POST /api/events returns 201"
    echo "Response: $BODY"
    EVENT_ID=$(echo $BODY | grep -o '"id":"[^"]*' | cut -d'"' -f4)
    echo "Created event ID: $EVENT_ID"
else
    echo "❌ FAIL: Expected 201, got $HTTP_CODE"
    echo "Response: $BODY"
fi
echo ""

# Test 3: Get specific event by ID
if [ ! -z "$EVENT_ID" ]; then
    echo "Test 3: Getting event by ID..."
    RESPONSE=$(curl -s -w "\n%{http_code}" "$BASE_URL/api/events/$EVENT_ID" \
        -H "Authorization: Bearer $TOKEN")
    HTTP_CODE=$(echo "$RESPONSE" | tail -n 1)
    BODY=$(echo "$RESPONSE" | head -n -1)

    if [ "$HTTP_CODE" = "200" ]; then
        echo "✅ PASS: GET /api/events/:id returns 200"
        echo "Response: $BODY"
    else
        echo "❌ FAIL: Expected 200, got $HTTP_CODE"
    fi
    echo ""
fi

# Test 4: Create event with validation errors (title too long)
echo "Test 4: Testing validation - title too long..."
LONG_TITLE=$(printf 'A%.0s' {1..201})
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/api/events" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{
        \"title\": \"$LONG_TITLE\",
        \"date\": \"2025-12-31\",
        \"budget\": 5000.00,
        \"description\": \"Test\",
        \"attendeeCount\": 100
    }")
HTTP_CODE=$(echo "$RESPONSE" | tail -n 1)

if [ "$HTTP_CODE" = "400" ]; then
    echo "✅ PASS: Title length validation returns 400"
else
    echo "❌ FAIL: Expected 400, got $HTTP_CODE"
fi
echo ""

# Test 5: Create event with past date
echo "Test 5: Testing validation - date in the past..."
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/api/events" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
        "title": "Past Event",
        "date": "2020-01-01",
        "budget": 5000.00,
        "description": "Test",
        "attendeeCount": 100
    }')
HTTP_CODE=$(echo "$RESPONSE" | tail -n 1)

if [ "$HTTP_CODE" = "400" ]; then
    echo "✅ PASS: Past date validation returns 400"
else
    echo "❌ FAIL: Expected 400, got $HTTP_CODE"
fi
echo ""

# Test 6: Create event with negative budget
echo "Test 6: Testing validation - negative budget..."
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/api/events" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
        "title": "Test Event",
        "date": "2025-12-31",
        "budget": -100.00,
        "description": "Test",
        "attendeeCount": 100
    }')
HTTP_CODE=$(echo "$RESPONSE" | tail -n 1)

if [ "$HTTP_CODE" = "400" ]; then
    echo "✅ PASS: Negative budget validation returns 400"
else
    echo "❌ FAIL: Expected 400, got $HTTP_CODE"
fi
echo ""

# Test 7: Create event with zero attendees
echo "Test 7: Testing validation - zero attendees..."
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/api/events" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
        "title": "Test Event",
        "date": "2025-12-31",
        "budget": 5000.00,
        "description": "Test",
        "attendeeCount": 0
    }')
HTTP_CODE=$(echo "$RESPONSE" | tail -n 1)

if [ "$HTTP_CODE" = "400" ]; then
    echo "✅ PASS: Zero attendees validation returns 400"
else
    echo "❌ FAIL: Expected 400, got $HTTP_CODE"
fi
echo ""

# Test 8: Try to access events without authentication
echo "Test 8: Testing authorization - access without token..."
RESPONSE=$(curl -s -w "\n%{http_code}" "$BASE_URL/api/events")
HTTP_CODE=$(echo "$RESPONSE" | tail -n 1)

if [ "$HTTP_CODE" = "401" ]; then
    echo "✅ PASS: Unauthenticated request returns 401"
else
    echo "❌ FAIL: Expected 401, got $HTTP_CODE"
fi
echo ""

echo "========================================="
echo "Event API Tests Complete"
echo "========================================="
