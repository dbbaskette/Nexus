# Nexus MCP Gateway Development Plan

## Goal

Deliver a unified Nexus MCP Gateway that can securely connect to multiple backend MCP servers as a client, expose a single MCP surface for downstream consumers, and provide an operator-friendly UI for managing connectivity, security, and observability.

## Guiding Principles

- Align with Spring Boot 3.5.6, Maven build lifecycle, and the documented local/cloud profile strategy.
- Favor layered architecture (Controller → Service → Repository) with DTO boundaries and constructor injection.
- Enforce structured logging with correlation IDs, comprehensive test coverage (JUnit 5 + Testcontainers where appropriate), and automated quality gates before deployment.
- Externalize configuration, avoid hard-coded secrets, and keep local/prod separation via Spring profiles and Cloud Foundry manifest configuration.

---

## Phase 0: Foundations & Environment Readiness

**Objective:** Establish the baseline project scaffolding, local tooling, and operational guardrails before feature development.

**Finalized Decisions:**
- **Project Structure:** Monolithic Maven project with clean package separation by domain
- **Database:** Testcontainers for local dev (no schema migration tools needed, manual schema management)
- **UI Technology:** Modern SPA (React/Vue) served via Spring Boot for metallic/liquid-glass theme
- **Security:** JWT token creation capabilities in API/UI from Phase 0 (enforcement comes in Phase 3)
- **Docker:** Fresh start with Testcontainers + docker-compose for local fixture servers
- **MCP Client:** Spring AI MCP Client Boot Starter with SYNC client type initially

**Key Tasks**
- Initialize Maven project with parent POM, import Spring AI 1.1.0-M3 BOM, and lock dependency versions (Spring Boot 3.5.6, Spring Cloud Gateway 4.3.1, springdoc-openapi, Micrometer/OpenTelemetry exporters).
- Add Spring AI MCP client boot starter (`spring-ai-starter-mcp-client`) and MCP server boot starter dependencies.
- Scaffold base packages (`controller`, `service`, `repository`, `dto`, `config`, `security`, `ui`) and enable constructor injection defaults.
- Configure profiles: `application-local.yml` for Testcontainers Postgres, `application-cloud.yml` for Cloud Foundry bindings, plus profile-specific logging and security toggles.
- Provision Postgres via Testcontainers for local dev with ServiceConnection; document Cloud Foundry managed Postgres binding requirements.
- Create initial schema manually (server registry tables, user/token tables, audit logs) with DDL scripts in `src/main/resources/schema/`.
- Enable Spring Security baseline with JWT token generation/validation, CSRF protection, secure session management, and CORS rules for SPA origin.
- Integrate structured logging (Logback with JSON encoder, MDC-based correlation IDs) and expose Actuator endpoints (health, metrics, info, readiness).
- Create docker-compose.yml for MCP fixture servers (stdio, SSE, Streamable HTTP) using spring-ai-examples reference implementations.
- Author container build scripts (`scripts/build-mcp-fixtures.sh`) that clone and package reference MCP servers into local Docker images for testing.
- Set up GitHub Actions CI workflow to run `mvn clean verify` and basic static analysis (optional: Spotless/Checkstyle).
- Create SPA skeleton structure (`ui/` directory) with build integration into Maven lifecycle (frontend-maven-plugin).
- Document local onboarding steps in `README.md` with diagrams (Docker fixtures, Testcontainers, run scripts, profile usage).

**Deliverables**
- Working Maven build (`mvn clean package`) with baseline modules and tests.
- Documented local setup scripts (`run-local.sh/.bat`) and Docker Compose for Postgres.
- CI pipeline config validating builds and tests on each push.

**Dependencies**
- Access to Docker locally, Cloud Foundry target/org/space for future verification.

---

## Phase 1: Multi-Server MCP Client Integration & Admin UI

**Objective:** Connect Nexus to multiple MCP servers, persist configuration, and surface tool inventories through a modern operator console.

**Key Tasks**
- Expand SPA UI with metallic/liquid-glass theme implementation; establish shared design system components and accessibility checks.
- Model MCP server metadata (name, base URL, auth requirements, tags) and tool descriptors within domain DTOs/entities.
- Implement repository/service layers for CRUD operations on MCP servers and tool caches, using Postgres persistence and optimistic locking.
- Build REST APIs (versioned under `/api/v1`) for server registration, verification, health status, and tool listing. Ensure validation, standardized error payloads, and OpenAPI documentation.
- Integrate Spring AI MCP client to establish connections per registered server supporting stdio, SSE, and Streamable HTTP transports; handle credential injection, retries, and circuit breaking (Resilience4j).
- Schedule background sync jobs to refresh tool catalogs, detect schema changes, and emit metrics/events.
- Develop UI flows: add/edit/delete server, connectivity test, tool browsing with filtering/tagging, health indicators, and audit trails. Include role-based visibility hooks for later security layers.
- Implement unit tests (services, repositories), integration tests (MCP client interactions via mock servers/Testcontainers), and UI or API contract tests.
- Seed integration tests with reference MCP server implementations from `spring-projects/spring-ai-examples/model-context-protocol` via Testcontainers pulling the locally built fixture images, validating stdio/SSE/Streamable HTTP compatibility.
- Emit metrics (Micrometer timers/counters for sync latency, tool counts) and structured logs for each MCP interaction.

**Outcome**
- Operators can register multiple MCP servers, view their available tools, and monitor connectivity from the UI and API.

**Dependencies**
- Completion of Phase 0 scaffolding; design assets for UI theme.

---

## Phase 2: Front-Facing MCP Server & Intelligent Routing

**Objective:** Expose Nexus as an MCP server and faithfully route client requests to the correct backend MCP tool with resilience and observability.

**Key Tasks**
- Define gateway routing model: route selection rules, tenancy boundaries, per-client rate limits, and protocol translation requirements.
- Implement Spring Cloud Gateway configuration for MCP endpoints, enforcing Streamable HTTP as the outward-facing protocol, and include request/response filters for authentication headers, tracing IDs, and payload transformation.
- Create mapping services that translate incoming MCP method calls into backend requests using stored server/tool metadata; support synchronous and streaming responses where applicable.
- Provide translation layers that bridge Streamable HTTP client calls to backend transports (stdio/SSE/Streamable HTTP) while preserving streaming semantics and backpressure.
- Provide fallback strategies (retry policies, circuit breakers) and define standardized error responses for downstream clients.
- Capture detailed audit logs for each routed request (client ID, target server/tool, latency, outcome) and expose via secured admin endpoint.
- Expand automated tests: contract tests ensuring request routing accuracy, chaos testing scenarios for backend outages, and performance smoke tests.
- Update OpenAPI docs and operator guides to include MCP routing configuration and troubleshooting steps.

**Outcome**
- Nexus offers a stable MCP endpoint that proxies to all registered backend servers with transparent routing and monitoring.

**Dependencies**
- Phase 1 completion (server registry, MCP client capabilities).

---

## Phase 3: Security, Access Control & Governance

**Objective:** Enforce token-based access, define user-to-tool permissions, and provide administrative governance features.

**Key Tasks**
- Extend Spring Security configuration with token issuance/validation (e.g., JWT signed with rotating keys stored securely) and pluggable authentication providers.
- Build domain models for users, roles, and scoped access policies (per server/tool). Persist with auditing (createdBy/updatedBy timestamps).
- Develop admin UI/API for managing users, role assignments, token lifecycle, and policy enforcement. Support bulk operations and activity logs.
- Implement authorization filters within routing layer to ensure only authorized tool invocations proceed; log policy denials with correlation IDs.
- Add secure secrets handling (integration with environment variables or CF service bindings). Ensure secrets never surface in logs or responses.
- Establish comprehensive security testing: unit tests for policy evaluation, integration tests for token workflows, penetration testing checklist, and regular vulnerability scans.
- Update documentation (security architecture diagram, threat model summary, incident response checklist).

**Outcome**
- Nexus enforces fine-grained access controls, issues tokens, and provides auditors with traceable activity logs.

**Dependencies**
- Phases 1 & 2 routing and UI foundations.

---

## Phase 4: Observability, Deployment & Operational Excellence

**Objective:** Harden the platform for production, deliver Cloud Foundry deployment automation, and ensure ongoing monitoring/alerting.

**Key Tasks**
- Expand Micrometer metrics and integrate OpenTelemetry tracing exporters aligned with organizational APM tooling.
- Configure Actuator health groups (readiness/liveness) and custom endpoints for MCP connectivity diagnostics.
- Build deployment manifests (`manifest.yml`) alongside a parameterized `vars.yml`; standardize `cf push --var-file vars.yml` usage and document variable ownership (local vs. CI-supplied secrets).
- Automate CF deployment pipeline (CI/CD) with smoke tests post-deploy and staged rollbacks.
- Author runbooks: scaling, certificate rotation, token key management, database backup/restore, and incident response flows.
- Conduct load testing and resilience drills; tune thread pools, connection pools, and backpressure strategies.
- Maintain documentation updates (architecture diagrams, sequence diagrams for routing, onboarding playbooks with visuals per project conventions).

**Outcome**
- Nexus operates reliably in Cloud Foundry with observability, deployment automation, and actionable runbooks.

**Dependencies**
- Completion of Phases 1–3 to supply functional features worth deploying.

---

## Future Enhancements & Backlog Candidates

- **Server Discovery Automation:** APIs/webhooks for auto-registering MCP servers, supporting approval workflows.
- **Tenant Isolation:** Partition data and routing by tenant with dedicated namespaces and configurable quotas.
- **Advanced Analytics:** Dashboarding for tool usage trends, latency histograms, and anomaly detection.
- **Plugin Ecosystem:** Extensible interface for custom tool transformers or policy engines contributed by partners.
- **Disaster Recovery:** Multi-region deployments, active-active failover strategies, and automated chaos experiments.

---

## Environment Setup Reference

- **Local Development**
  - Use Postgres via Testcontainers (auto-started with @ServiceConnection); no manual DB setup required.
  - Run MCP fixture servers with `docker compose up` for integration testing against stdio/SSE/Streamable HTTP servers.
  - Run application with `./run-local.sh` to activate the `local` profile and enable verbose debugging.
  - Seed baseline data (admin user, sample MCP server) through dedicated bootstrap runner or REST API calls.
  - Build fixture MCP server images with `scripts/build-mcp-fixtures.sh` as part of initial setup; docker-compose references these locally tagged images.

- **Cloud Deployment**
  - Rely on Cloud Foundry managed Postgres; map credentials via VCAP services and `application-cloud.yml`.
  - Maintain a shared `vars.yml` (committed without sensitive values) for manifest interpolation; local runs reuse it while CI/production invoke `cf push --var-file vars.yml` with environment-specific overrides injected securely.
  - Deploy with `cf push` using the prepared manifest; ensure environment variables for token keys and external endpoints are sourced from secrets management.
  - Monitor via CF logs, configured APM integration, and Actuator endpoints secured behind admin authentication.

---

## Quality Gates & Documentation

- Maintain >90% line coverage on core services, with emphasis on authorization, routing, and error-handling paths.
- Require peer-reviewed PRs, static analysis compliance, and successful integration tests before merge.
- Keep OpenAPI specs and operator documentation current; update diagrams and onboarding guides with each major phase completion.
- Schedule regular retrospectives at the end of each phase to review metrics, technical debt, and upcoming backlog priorities.
