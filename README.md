# Event Planner Backend

Backend API for the Event Planner application.

## Setup

1. Install dependencies:
```bash
npm install
```

2. Create a `.env` file based on `.env.example`:
```bash
cp .env.example .env
```

3. Update the `.env` file with your PostgreSQL connection details.

4. Run database migrations:
```bash
npm run migrate
```

5. Start the development server:
```bash
npm run dev
```

## Available Scripts

- `npm run dev` - Start development server with hot reload
- `npm run build` - Build for production
- `npm start` - Start production server
- `npm test` - Run tests
- `npm run migrate` - Run database migrations

## Database Schema

The application uses PostgreSQL with the following tables:

- **users**: User accounts with authentication
- **events**: Event details (title, date, budget, etc.)
- **budget_items**: Budget line items for events
- **tasks**: Tasks associated with events

All tables include proper constraints, indexes, and foreign key relationships.

## API Endpoints

(To be documented as endpoints are implemented)

## Testing

The project uses Jest for unit testing and fast-check for property-based testing.

Run tests with:
```bash
npm test
```
