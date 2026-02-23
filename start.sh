#!/bin/bash

echo "========================================="
echo "Event Planner Backend - Java/Spring Boot"
echo "========================================="
echo ""

# Check if Java is installed
if ! command -v java &> /dev/null; then
    echo "❌ Java is not installed. Please install Java 17 or higher."
    exit 1
fi

# Check Java version
JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1)
if [ "$JAVA_VERSION" -lt 17 ]; then
    echo "❌ Java 17 or higher is required. Current version: $JAVA_VERSION"
    exit 1
fi

echo "✅ Java version: $(java -version 2>&1 | head -n 1)"

# Check if Maven is installed
if ! command -v mvn &> /dev/null; then
    echo "❌ Maven is not installed. Please install Maven 3.6 or higher."
    exit 1
fi

echo "✅ Maven version: $(mvn -version | head -n 1)"
echo ""

# Check if PostgreSQL is running
if ! pg_isready &> /dev/null; then
    echo "⚠️  Warning: PostgreSQL doesn't appear to be running."
    echo "   Please ensure PostgreSQL is running and the database 'eventplanner' exists."
    echo ""
fi

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "⚠️  No .env file found. Using default configuration from application.properties"
    echo "   Copy .env.example to .env and update with your settings."
    echo ""
fi

echo "Starting Spring Boot application..."
echo ""

# Run the application
mvn spring-boot:run
