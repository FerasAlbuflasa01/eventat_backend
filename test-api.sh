#!/bin/bash

BASE_URL="http://localhost:8080"

echo "========================================="
echo "Event Planner API Test Script"
echo "========================================="
echo ""
echo "Base URL: $BASE_URL"
echo ""

# Test 1: Health check (session endpoint without auth should return 401)
echo "Test 1: Testing unauthenticated session endpoint..."
RESPONSE=$(curl -s -w "\n%{http_code}" "$BASE_URL/api/auth/session")
HTTP_CODE=$(echo "$RESPONSE" | tail -n 1)
BODY=$(echo "$RESPONSE" | head -n -1)

if [ "$HTTP_CODE" = "401" ]; then
    echo "✅ PASS: Unauthenticated request correctly returns 401"
else
    echo "❌ FAIL: Expected 401, got $HTTP_CODE"
fi
echo ""

# Test 2: Login with invalid credentials
echo "Test 2: Testing login with invalid credentials..."
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/api/auth/login" \
    -H "Content-Type: application/json" \
    -d '{"email":"invalid@example.com","password":"wrongpassword"}')
HTTP_CODE=$(echo "$RESPONSE" | tail -n 1)

if [ "$HTTP_CODE" = "401" ]; then
    echo "✅ PASS: Invalid credentials correctly returns 401"
else
    echo "❌ FAIL: Expected 401, got $HTTP_CODE"
fi
echo ""

# Test 3: Login validation (missing fields)
echo "Test 3: Testing login validation..."
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/api/auth/login" \
    -H "Content-Type: application/json" \
    -d '{"email":""}')
HTTP_CODE=$(echo "$RESPONSE" | tail -n 1)

if [ "$HTTP_CODE" = "400" ]; then
    echo "✅ PASS: Missing fields correctly returns 400"
else
    echo "❌ FAIL: Expected 400, got $HTTP_CODE"
fi
echo ""

# Test 4: Logout endpoint
echo "Test 4: Testing logout endpoint..."
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL/api/auth/logout")
HTTP_CODE=$(echo "$RESPONSE" | tail -n 1)

if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ PASS: Logout endpoint returns 200"
else
    echo "❌ FAIL: Expected 200, got $HTTP_CODE"
fi
echo ""

echo "========================================="
echo "API Tests Complete"
echo "========================================="
echo ""
echo "Note: To test successful login, you need to:"
echo "1. Ensure the database is running"
echo "2. Create a test user in the database"
echo "3. Use valid credentials in the test script"
