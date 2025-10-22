# Code Assistant Configuration

## Versions & Dependencies

- **Spring Boot**: 3.5.6
- **Build Tool**: maven
- **Git Repository**: Yes

## Spring Projects

### spring-ai (1.1.0-M3)
📚 [Documentation](https://docs.spring.io/spring-ai/reference/1.1.0-M3/)

### spring-cloud-gateway (4.3.1)
📚 [Documentation](https://docs.spring.io/spring-cloud-gateway/reference/4.3.1/)

## Dev Workflow

```bash
# Build the project
mvn clean package

# Run tests
mvn test

# Run application
mvn spring-boot:run
```

## Cloud Foundry Deployment

```bash
# Deploy to Cloud Foundry
cf push
```

**Important:**
- Ensure `manifest.yml` is configured appropriately
- Set `SPRING_PROFILES_ACTIVE=cloud` in the manifest
- Dev/test work is local - maintain separate `-local` and `-cloud` profiles
- Use local run scripts for local development work


## Documentation to Consult First

- [spring-ai 1.1.0-M3](https://docs.spring.io/spring-ai/reference/1.1.0-M3/)
- [spring-cloud-gateway 4.3.1](https://docs.spring.io/spring-cloud-gateway/reference/4.3.1/)

## Policies

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
