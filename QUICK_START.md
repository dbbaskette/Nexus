# ⚡ Quick Start Guide

## 🚀 First Time Setup (5 minutes)

### 1. Clone & Build
```bash
git clone https://github.com/dbbaskette/Nexus.git
cd Nexus
mvn clean compile -Dskip.ui=true
```

### 2. Run the Application
```bash
./run-local.sh
```

That's it! 🎉

---

## 📍 Key URLs

| Service | URL | Description |
|---------|-----|-------------|
| **Main UI** | http://localhost:8080 | Dashboard & management console |
| **API Docs** | http://localhost:8080/swagger-ui.html | Interactive API documentation |
| **Health Check** | http://localhost:8080/actuator/health | Application health status |
| **Metrics** | http://localhost:8080/actuator/metrics | Prometheus metrics |
| **Vue Dev Server** | http://localhost:5173 | (Optional) Hot-reload UI development |

---

## 🛠️ Common Commands

### Backend Development
```bash
# Compile Java code only
mvn clean compile -Dskip.ui=true

# Run application
./run-local.sh

# Run tests
mvn test -Dskip.ui=true

# Package JAR
mvn clean package -Dskip.ui=true
```

### Frontend Development
```bash
# Install dependencies (first time only)
cd ui
npm install

# Run dev server with hot reload
npm run dev

# Build for production
npm run build
```

### Docker Fixtures (MCP Test Servers)
```bash
# Build Docker images
./scripts/build-mcp-fixtures.sh

# Start all MCP servers
docker-compose up -d

# View logs
docker-compose logs -f

# Stop servers
docker-compose down

# Check status
docker-compose ps
```

---

## 🔐 Default Credentials

**Username**: `admin`
**Password**: `admin123`

> ⚠️ **IMPORTANT**: Change in production! This is only for local development.

---

## 🏗️ MCP Fixture Servers

After running `docker-compose up -d`:

| Server | Port | Type | Tools |
|--------|------|------|-------|
| **Weather** | 8081 | SSE | Weather data retrieval |
| **Filesystem** | 8082 | SSE | File operations |
| **SQLite** | 8083 | SSE | Database queries |

---

## 🎯 Development Workflow

### Option A: Backend + Vue Dev Server (Recommended)
```bash
# Terminal 1: Backend
./run-local.sh

# Terminal 2: Frontend with hot reload
cd ui && npm run dev

# Open browser to http://localhost:5173
```

### Option B: Backend Only
```bash
# Run backend (UI bundled from last build)
./run-local.sh

# Open browser to http://localhost:8080
```

### Option C: Full Build with UI
```bash
# Build everything (requires network for npm)
mvn clean package

# Run
java -jar target/nexus-0.1.0-SNAPSHOT.jar --spring.profiles.active=local
```

---

## 🐛 Troubleshooting

### Build fails with "Could not download npm"
```bash
# Use the skip flag
mvn clean compile -Dskip.ui=true
```

See [KNOWN_ISSUES.md](KNOWN_ISSUES.md) for full troubleshooting guide.

### Application won't start
```bash
# Check Docker is running
docker ps

# Testcontainers needs Docker
open -a Docker  # macOS
```

### Can't access http://localhost:8080
```bash
# Check if port 8080 is in use
lsof -i :8080

# Or use a different port
mvn spring-boot:run -Dspring-boot.run.profiles=local -Dserver.port=8888
```

---

## 📚 Learn More

- **Full Documentation**: [README.md](README.md)
- **Phase 0 Details**: [PHASE0_COMPLETE.md](PHASE0_COMPLETE.md)
- **Troubleshooting**: [KNOWN_ISSUES.md](KNOWN_ISSUES.md)
- **GitHub**: https://github.com/dbbaskette/Nexus

---

## 🎨 UI Features Available

✅ Dashboard with glassmorphism design
✅ Server health monitoring
✅ Recent activity feed
✅ Stats visualization
⏳ Server management (Phase 1)
⏳ Tool browser (Phase 1)
⏳ Token generation UI (Phase 1)

---

## 🚦 Health Check

```bash
# Quick health check
curl http://localhost:8080/actuator/health

# Expected output:
# {"status":"UP"}
```

---

## 💡 Pro Tips

1. **Skip UI builds during development**: Always use `-Dskip.ui=true`
2. **Use Vue dev server for UI work**: Hot reload is much faster
3. **Keep Docker running**: Testcontainers needs it for Postgres
4. **Check the logs**: Look for correlation IDs in error messages
5. **Use Swagger UI**: Great for testing APIs without curl

---

**Happy Coding! 🎉**
