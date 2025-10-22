# Project Rules

## Project Configuration
- Build Tool: maven
- Spring Boot Version: 3.5.6
- Git Repository: Initialized

## Selected Spring Projects

### spring-ai
- Version: 1.1.0-M3
- Root Documentation: https://docs.spring.io/spring-ai/reference/1.1.0-M3/
- https://docs.spring.io/spring-ai/reference/1.1/api/tools.html
https://docs.spring.io/spring-ai/reference/1.1/api/mcp/mcp-overview.html
https://docs.spring.io/spring-ai/reference/1.1/api/mcp/mcp-client-boot-starter-docs.html
https://docs.spring.io/spring-ai/reference/1.1/api/mcp/mcp-server-boot-starter-docs.html
https://docs.spring.io/spring-ai/reference/1.1/api/mcp/mcp-stdio-sse-server-boot-starter-docs.html
https://docs.spring.io/spring-ai/reference/1.1/api/mcp/mcp-streamable-http-server-boot-starter-docs.html
https://docs.spring.io/spring-ai/reference/1.1/api/mcp/mcp-stateless-server-boot-starter-docs.html
https://docs.spring.io/spring-ai/reference/1.1/api/mcp/mcp-security.html
https://docs.spring.io/spring-ai/reference/1.1/api/mcp/mcp-annotations-overview.html
https://docs.spring.io/spring-ai/reference/1.1/api/mcp/mcp-annotations-client.html
https://docs.spring.io/spring-ai/reference/1.1/api/mcp/mcp-annotations-server.html
https://docs.spring.io/spring-ai/reference/1.1/api/mcp/mcp-annotations-special-params.html
https://docs.spring.io/spring-ai/reference/1.1/api/mcp/mcp-annotations-examples.html

### spring-cloud-gateway
- Version: 4.3.1
- Root Documentation: https://docs.spring.io/spring-cloud-gateway/reference/4.3.1/
- No specific pages selected (use root documentation)

## Build & Test Commands

- Build: `mvn clean package`
- Test: `mvn test`
- Run: `mvn spring-boot:run`

## Cloud Foundry Deployment

### Deployment
- Deploy to Cloud Foundry: `cf push`
- Ensure a `manifest.yml` file is created with appropriate configuration

### Manifest Template
```yaml
---
applications:
- name: your-app-name
  memory: 1G
  instances: 1
  path: target/app.jar
  buildpacks:
    - java_buildpack
  env:
    SPRING_PROFILES_ACTIVE: cloud
```

### Local Development (Production-Only CF Deployment)
Since dev/test work is done locally, create separate Spring profiles:

- **local profile**: For local development work
  - `application-local.properties` or `application-local.yml`
- **cloud profile**: For Cloud Foundry production deployment
  - `application-cloud.properties` or `application-cloud.yml`

### Local Run Scripts
Create run scripts for local development work:

**run-local.sh** (macOS/Linux):
```bash
#!/bin/bash
mvn spring-boot:run -Dspring-boot.run.profiles=local
```

**run-local.bat** (Windows):
```batch
mvn spring-boot:run -Dspring-boot.run.profiles=local
```


## Guidelines
- Follow Spring best practices for dependency injection and use constructor injection over field injection
- Generate JUnit 5 tests for all new code with minimal reproducible examples
- Refer to official Spring documentation before making changes
- Follow conventional Spring project structure (src/main/java, src/main/resources) with logical package layout by domain
- Write clear, self-documenting code with Javadoc for public APIs; prefer meaningful names over abbreviations
- After code changes, compile and iteratively fix all errors until compilation succeeds
- Favor clean layered architecture: Controller -> Service -> Repository with DTOs for inputs/outputs; keep controllers thin
- Adhere to Google Java Style Guide and maintain consistency across the codebase
- Avoid anti-patterns: excessive static state, large monolithic methods, Lombok overuse that hinders readability
- Prefer Spring Boot starters and avoid unused transitive dependencies
- Design RESTful endpoints with consistent URI structures, HTTP verbs, and status codes
- Version APIs (e.g., /api/v1) and document with OpenAPI/Swagger using springdoc-openapi
- Use standardized error payloads with consistent exception mapping to HTTP status codes
- Secure endpoints with Spring Security by default; enable CSRF protection, secure session management, and proper CORS controls
- Never leak sensitive information in responses; avoid hard-coding secrets
- Enable structured logging with correlation IDs and integrate Spring Boot Actuator for metrics and health checks
- Use Micrometer for metrics collection and consider distributed tracing with OpenTelemetry
- Externalize configuration with profiles (e.g., application-dev.yml, application-prod.yml); use environment variables or secret stores for credentials
- When proposing changes, show rationale and alignment with these rules
- Recommend incremental changes that can be reviewed, tested, and merged without destabilizing existing behavior
- Clearly separate repository and service boundaries; use DTOs to shape exposed data
- Document threading and backpressure considerations when using thread pools, schedulers, or parallel streams
- Maintain READMEs with colors, icons, different header sizes, and diagrams; provide onboarding guides and example workflows
