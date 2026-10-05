# Nalanda Platform

The project is split into independent applications:

```text
nalanda_backend_api/
├── backend/     Spring Boot REST API
└── frontend/    Standalone dashboard UI
```

## Backend

```bash
cd backend
mvn spring-boot:run
```

The API runs at `http://localhost:8080/api`.

## Frontend

In a second terminal:

```bash
cd frontend
python3 -m http.server 5500
```

Open `http://localhost:5500`. The dashboard is configured to call the backend at `http://localhost:8080/api`.