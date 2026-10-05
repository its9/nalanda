# Nalanda Backend API

Spring Boot foundation for the Nalanda training management platform.

## Run

```bash
mvn spring-boot:run
```

The API is available under `http://localhost:8080/api`.

## MySQL schema

The supplied database design is split into ordered table files under `src/main/resources/db/`. Each file contains one `CREATE TABLE` statement and creates no default records.

MySQL connection settings are available in `application.yml` and `application-mysql.yml`, and read from `DB_URL`, `DB_USERNAME`, and `DB_PASSWORD`. The default backend profile connects to MySQL. Start with MySQL enabled explicitly using:

```bash
DB_USERNAME=root DB_PASSWORD= mvn spring-boot:run -Dspring-boot.run.profiles=mysql
```

The schema scripts are ready for the database, while feature services are still being migrated from in-memory storage to repositories.

To create the schema directly with MySQL:

```bash
for file in src/main/resources/db/*.sql; do
	mysql -u root bel_training_management < "$file"
done
```

## Feature-based structure

Each API module lives in its own package under `src/main/java/com/nalanda/api/feature`:

```text
feature/
├── employees/
│   ├── EmployeesController.java
│   ├── EmployeesService.java
│   ├── EmployeesRepository.java
│   └── EmployeesEntity.java
├── programs/
├── attendance/
├── nominations/
└── ...
```

Add a module's controller, service, repository, entity, DTOs, and tests inside that module's folder. Shared error handling and response types belong in `common/`.

The application follows MVC for REST APIs:

- `Controller`: maps HTTP requests and delegates to the service.
- `Service`: contains feature business logic and coordinates repositories.
- `Model`: contains feature entities and request/response DTOs.
- `Repository`: contains persistence access for the feature.
- `common/`: contains cross-feature error handling and shared response types.

## Initial endpoints

- `GET /api/system/health`
- `POST /api/auth/login`
- `POST /api/auth/logout`
- `POST /api/auth/refresh`
- `POST /api/auth/forgot-password`
- `POST /api/auth/reset-password`
- `GET /api/auth/me`
- `PUT /api/auth/change-password`
- `GET /api/dashboard/summary`
- `GET /api/dashboard/programs`
- `GET /api/dashboard/attendance`
- `GET /api/dashboard/nominations`
- `GET /api/dashboard/employees`
- `GET /api/dashboard/faculty`
- `GET /api/dashboard/halls`
- `GET /api/dashboard/training-hours`
- `GET /api/dashboard/mandays`
- `GET /api/dashboard/monthly`
- `GET /api/dashboard/yearly`
- `GET /api/employees`
- `GET /api/employees/{id}`
- `POST /api/employees`
- `PUT /api/employees/{id}`
- `DELETE /api/employees/{id}`
- `GET /api/employees/search?name=Arun`
- `GET /api/employees/search?employeeId=EMP1001`
- `GET /api/employees?department=QUALITY`
- `GET /api/employees?wing=QUALITY`
- `GET /api/employees/{id}/programs`
- `GET /api/employees/{id}/nominations`
- `GET /api/employees/{id}/attendance`
- `GET /api/employees/{id}/certificates`
- `GET /api/employees/{id}/training-history`
- `POST /api/employees/import`
- `GET /api/employees/export`
- `GET /api/employees/template`
- `GET /api/departments`
- `GET /api/departments/{id}`
- `POST /api/departments`
- `PUT /api/departments/{id}`
- `DELETE /api/departments/{id}`
- `GET /api/departments/{id}/employees`
- `GET /api/wings`
- `GET /api/wings/{id}`
- `POST /api/wings`
- `PUT /api/wings/{id}`
- `DELETE /api/wings/{id}`
- `GET /api/programs`
- `GET /api/programs/{id}`
- `POST /api/programs`
- `PUT /api/programs/{id}`
- `DELETE /api/programs/{id}`
- `GET /api/programs/search?name=Quality`
- `GET /api/programs?wing=QUALITY&type=INTERNAL&status=ONGOING&year=2026&month=9`
- `GET /api/programs/{id}/participants`
- `GET /api/programs/{id}/nominations`
- `GET /api/programs/{id}/attendance`
- `GET /api/programs/{id}/faculty`
- `GET /api/programs/{id}/documents`
- `GET /api/programs/{id}/feedback`
- `GET /api/programs/{id}/report`
- `PUT /api/programs/{id}/start`
- `PUT /api/programs/{id}/complete`
- `PUT /api/programs/{id}/cancel`
- `PUT /api/programs/{id}/postpone`
- `GET /api/employees`
- `GET /api/departments`
- `GET /api/wings`
- `GET /api/programs`
- `GET /api/nominations`
- `GET /api/attendance`
- `GET /api/faculty`
- `GET /api/halls`
- `GET /api/reports`
- `GET /api/documents`
- `GET /api/feedback`
- `GET /api/users`
- `GET /api/roles`
- `GET /api/permissions`
- `GET /api/settings`
- `GET /api/backup`
- `GET /api/audit`
- `GET /api/notifications`
- `GET /api/docs`
- `GET /api/swagger-ui.html`

Authentication currently runs in development mode. JWTs are signed and expire after the configured lifetime, but token revocation, persistent users, password storage, and password-reset delivery require a user repository and should be added before production deployment.