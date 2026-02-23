# Event Planner Backend (Java/Spring Boot)

This is the backend API for the Event Planner application, built with Java and Spring Boot.

## Prerequisites

- Java 17 or higher
- Maven 3.6+
- PostgreSQL 12+

## Setup

1. Create a PostgreSQL database:
```sql
CREATE DATABASE eventplanner;
```

2. Update database credentials in `src/main/resources/application.properties`:
```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/eventplanner
spring.datasource.username=your_username
spring.datasource.password=your_password
```

3. Update JWT secret in `application.properties` (use a secure random string):
```properties
jwt.secret=your-secret-key-change-this-in-production-make-it-at-least-256-bits-long
```

## Running the Application

### Using Maven

```bash
mvn spring-boot:run
```

### Building and Running JAR

```bash
mvn clean package
java -jar target/eventat-backend-1.0.0.jar
```

The application will start on `http://localhost:8080`.

## Database Migrations

Database migrations are handled automatically by Flyway on application startup. Migration files are located in `src/main/resources/db/migration/`.

## API Endpoints

### Authentication

- `POST /api/auth/login` - Login with email and password
- `POST /api/auth/logout` - Logout (client-side token removal)
- `GET /api/auth/session` - Get current session information

### Events (Coming Soon)

- `GET /api/events` - Get all events for authenticated user
- `POST /api/events` - Create a new event
- `GET /api/events/:id` - Get event details

### Budget Items (Coming Soon)

- `GET /api/events/:eventId/budget-items` - Get budget items for an event
- `POST /api/events/:eventId/budget-items` - Add a budget item

### Tasks (Coming Soon)

- `GET /api/events/:eventId/tasks` - Get tasks for an event
- `POST /api/events/:eventId/tasks` - Create a task

## Authentication

The API uses JWT (JSON Web Tokens) for authentication. After logging in, include the token in the Authorization header:

```
Authorization: Bearer <your-token>
```

## Testing

Run tests with:

```bash
mvn test
```

## Project Structure

```
src/
├── main/
│   ├── java/com/eventplanner/
│   │   ├── config/          # Configuration classes
│   │   ├── controller/      # REST controllers
│   │   ├── dto/             # Data Transfer Objects
│   │   ├── entity/          # JPA entities
│   │   ├── exception/       # Exception handlers
│   │   ├── repository/      # Spring Data repositories
│   │   ├── security/        # Security components
│   │   └── service/         # Business logic
│   └── resources/
│       ├── db/migration/    # Flyway migrations
│       └── application.properties
└── test/                    # Test files
```

## Technologies Used

- Spring Boot 3.2.0
- Spring Security
- Spring Data JPA
- PostgreSQL
- Flyway (database migrations)
- JWT (authentication)
- Lombok (boilerplate reduction)
- BCrypt (password hashing)
