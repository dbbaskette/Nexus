# 🌟 Nexus MCP Gateway

<div align="center">

![Nexus Gateway](https://img.shields.io/badge/Spring%20Boot-3.5.6-brightgreen?style=for-the-badge&logo=springboot)
![Spring AI](https://img.shields.io/badge/Spring%20AI-1.1.0--M3-blue?style=for-the-badge)
![Vue 3](https://img.shields.io/badge/Vue-3.5-42b883?style=for-the-badge&logo=vue.js)
![License](https://img.shields.io/badge/License-MIT-purple?style=for-the-badge)

**A unified gateway for managing and routing to multiple backend MCP (Model Context Protocol) servers**

[Features](#-features) •
[Quick Start](#-quick-start) •
[Architecture](#-architecture) •
[Development](#-development) •
[Deployment](#-deployment) •
[Troubleshooting](KNOWN_ISSUES.md)

</div>

---

## 📋 Overview

Nexus MCP Gateway provides a centralized hub for connecting to multiple Model Context Protocol (MCP) servers, offering:

- **🔌 Multi-Server Connectivity**: Connect to unlimited MCP servers via STDIO, SSE, or Streamable HTTP
- **🛡️ Security & Access Control**: JWT-based authentication with fine-grained tool access policies
- **🎨 Modern UI**: Sleek metallic/liquid glass design for intuitive server and tool management
- **📊 Observability**: Built-in metrics, distributed tracing, and comprehensive audit logging
- **☁️ Cloud Native**: Designed for Cloud Foundry with Testcontainers for local development

---

## ✨ Features

### Phase 0 (Current) - Foundations
- ✅ Maven project structure with Spring Boot 3.5.6
- ✅ Spring AI MCP client and server support
- ✅ JWT token generation and validation
- ✅ Testcontainers-based Postgres integration
- ✅ Structured logging with correlation IDs
- ✅ Docker fixtures for test MCP servers
- ✅ Vue 3 SPA with glassmorphism UI
- ✅ Spring Boot Actuator endpoints

### Roadmap
- 🔄 **Phase 1**: Multi-server MCP client integration & admin UI
- 🔄 **Phase 2**: Front-facing MCP server & intelligent routing
- 🔄 **Phase 3**: Fine-grained access control & governance
- 🔄 **Phase 4**: Production deployment & operational excellence

---

## 🚀 Quick Start

### Prerequisites

- **Java 21+** (Eclipse Temurin or OpenJDK)
- **Maven 3.9+**
- **Docker** (for MCP fixture servers)
- **Node.js 20+** (for UI development)

### 1. Clone and Build

```bash
# Clone the repository
git clone https://github.com/dbbaskette/Nexus.git
cd Nexus

# Build the project (skip UI to avoid npm registry issues)
mvn clean package -Dskip.ui=true
```

> 💡 **Tip**: The UI build requires network access to NPM. Use `-Dskip.ui=true` for backend-only development, or run `cd ui && npm run dev` for UI hot reload. See [KNOWN_ISSUES.md](KNOWN_ISSUES.md) for more details.

### 2. Start MCP Fixture Servers

```bash
# Build Docker images for test MCP servers
./scripts/build-mcp-fixtures.sh

# Start fixture servers (weather, filesystem, sqlite)
docker-compose up -d

# Verify servers are running
docker-compose ps
```

### 3. Run the Application

```bash
# Option A: Run with Testcontainers (recommended for development)
./run-local.sh

# Option B: Run via Maven directly
mvn spring-boot:run -Dspring-boot.run.profiles=local
```

### 4. Access the UI

Open your browser to:
- **UI Dashboard**: http://localhost:8080
- **API Documentation**: http://localhost:8080/swagger-ui.html
- **Actuator Health**: http://localhost:8080/actuator/health

### 5. Develop the UI (Optional)

```bash
cd ui
npm install
npm run dev
```

The Vue dev server will run on `http://localhost:5173` with hot-reload enabled.

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Nexus MCP Gateway                        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐  │
│  │   Vue SPA    │◄───│  Spring MVC  │◄───│   Security   │  │
│  │ (UI Layer)   │    │ (REST API)   │    │    (JWT)     │  │
│  └──────────────┘    └──────────────┘    └──────────────┘  │
│                                                              │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐  │
│  │ MCP Server   │◄───│  Gateway     │◄───│  MCP Client  │  │
│  │ (Streamable) │    │  (Routing)   │    │  (Multi-Srv) │  │
│  └──────────────┘    └──────────────┘    └──────────────┘  │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              Postgres + Audit Logs                    │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
          │                 │                 │
          ▼                 ▼                 ▼
    ┌──────────┐      ┌──────────┐      ┌──────────┐
    │ Weather  │      │Filesystem│      │  SQLite  │
    │MCP Server│      │MCP Server│      │MCP Server│
    └──────────┘      └──────────┘      └──────────┘
```

### Key Components

| Component | Technology | Purpose |
|-----------|-----------|---------|
| **Backend** | Spring Boot 3.5.6 | Core application framework |
| **MCP Support** | Spring AI 1.1.0-M3 | MCP client/server implementation |
| **Gateway** | Spring Cloud Gateway 4.3.1 | Request routing and filtering |
| **Security** | Spring Security + JWT | Authentication and authorization |
| **Database** | Postgres 16 | Persistent storage |
| **Frontend** | Vue 3 + Tailwind CSS | Modern glassmorphism UI |
| **Observability** | Micrometer + OpenTelemetry | Metrics and tracing |
| **Testing** | Testcontainers | Integration testing |

---

## 🛠️ Development

### Project Structure

```
Nexus/
├── src/
│   ├── main/
│   │   ├── java/com/baskettecase/nexus/
│   │   │   ├── config/          # Configuration classes
│   │   │   ├── controller/      # REST controllers
│   │   │   ├── service/         # Business logic
│   │   │   ├── repository/      # Data access
│   │   │   ├── dto/             # Data transfer objects
│   │   │   ├── security/        # Security components
│   │   │   └── mcp/             # MCP client/server logic
│   │   └── resources/
│   │       ├── application*.yml # Spring profiles
│   │       ├── schema/          # Database DDL scripts
│   │       └── static/          # Built UI assets
│   └── test/
│       └── java/com/baskettecase/nexus/
├── ui/                          # Vue 3 SPA
│   ├── src/
│   │   ├── components/          # Reusable UI components
│   │   ├── views/               # Page views
│   │   ├── router/              # Vue Router config
│   │   ├── stores/              # Pinia state management
│   │   └── assets/              # Styles and assets
│   └── package.json
├── docker/                      # Docker fixtures
│   └── fixtures/
│       ├── weather/
│       ├── filesystem/
│       └── sqlite/
├── scripts/                     # Build scripts
├── pom.xml                      # Maven configuration
└── docker-compose.yml          # MCP test servers
```

### Running Tests

```bash
# Run all tests
mvn test

# Run with coverage
mvn clean verify

# Run specific test
mvn test -Dtest=NexusApplicationTest
```

### Database Schema

The database schema is located in `src/main/resources/schema/schema.sql` and includes:

- **Users & Authentication**: User accounts, roles, JWT tokens
- **MCP Server Registry**: Registered MCP servers and their configurations
- **MCP Tools Cache**: Discovered tools from connected servers
- **Access Policies**: Fine-grained access control rules
- **Audit Logs**: Comprehensive activity tracking

### Default Credentials

For local development, a default admin user is created:

- **Username**: `admin`
- **Password**: `admin123`
- **Email**: `admin@nexus.local`

⚠️ **Change these credentials immediately in production!**

---

## ☁️ Deployment

### Cloud Foundry

```bash
# Deploy to Cloud Foundry
cf push

# Set environment variables
cf set-env nexus-mcp-gateway JWT_SECRET "your-production-secret-key"
cf set-env nexus-mcp-gateway CORS_ALLOWED_ORIGINS "https://your-domain.com"

# Restart the app
cf restage nexus-mcp-gateway
```

### Manifest Configuration

The `manifest.yml` is automatically generated. Key environment variables:

| Variable | Description | Required |
|----------|-------------|----------|
| `JWT_SECRET` | Secret key for JWT signing (min 256 bits) | Yes |
| `CORS_ALLOWED_ORIGINS` | Comma-separated allowed origins | Yes |
| `SPRING_PROFILES_ACTIVE` | Active Spring profile (`cloud`) | Yes |

---

## 📊 Monitoring

### Actuator Endpoints

- `/actuator/health` - Health check (readiness/liveness)
- `/actuator/metrics` - Micrometer metrics
- `/actuator/prometheus` - Prometheus-formatted metrics
- `/actuator/info` - Application information

### Logging

Structured JSON logs are emitted in the `cloud` profile. Correlation IDs are automatically added to:
- HTTP response headers (`X-Correlation-ID`)
- Log entries (MDC)
- Distributed traces

---

## 🔐 Security

### JWT Token Flow

1. Client authenticates with username/password
2. Server generates JWT token (signed with HS256)
3. Client includes token in `Authorization: Bearer <token>` header
4. Server validates token and extracts user claims

### CORS Configuration

CORS is configured per environment:
- **Local**: `http://localhost:5173`, `http://localhost:8080`
- **Cloud**: Configured via `CORS_ALLOWED_ORIGINS` environment variable

---

## 📚 API Documentation

Interactive API documentation is available via Swagger UI:

👉 **http://localhost:8080/swagger-ui.html**

OpenAPI 3.0 JSON schema:

👉 **http://localhost:8080/api-docs**

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📝 License

This project is licensed under the MIT License.

---

## 🙏 Acknowledgments

- [Spring AI Examples](https://github.com/spring-projects/spring-ai-examples) for MCP reference servers
- Spring Boot and Spring AI teams for excellent framework support
- Model Context Protocol community for the standardized protocol

---

<div align="center">

**Built with ❤️ using Spring Boot, Spring AI, and Vue 3**

[Report Bug](https://github.com/dbbaskette/Nexus/issues) •
[Request Feature](https://github.com/dbbaskette/Nexus/issues)

</div>
