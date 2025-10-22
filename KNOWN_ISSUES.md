# Known Issues & Workarounds

## ✅ Resolved Issues

### Testcontainers Not Starting Postgres
**Status**: ✅ Fixed in latest commit

**Problem**: Application failed with:
```
Connection to localhost:5432 refused
Unable to determine Dialect without JDBC metadata
```

**Root Cause**: Running `mvn spring-boot:run` uses main application configuration, which expects Postgres at `localhost:5432`. Testcontainers configuration is in the test classpath.

**Solution**: Use `mvn spring-boot:test-run` instead, which:
- Runs `TestNexusApplication` with Testcontainers configuration
- Automatically starts Postgres in Docker
- Uses `@ServiceConnection` to configure datasource

The `./run-local.sh` script now uses the correct goal and checks for Docker.

### Spring Boot 3.x Error Property Configuration
**Status**: ✅ Fixed in latest commit

**Problem**: Application failed to start with:
```
Failed to bind properties under 'server.error.include-message' to ErrorProperties$IncludeAttribute
```

**Solution**: Changed from boolean `true` to enum value `always` in `application.yml`.

Spring Boot 3.x requires one of: `ALWAYS`, `NEVER`, or `ON_PARAM`.

---

## NPM Registry Connection Issues

### Problem
When running `mvn clean package` or `./run-local.sh`, you may encounter:
```
Could not download npm: Could not download https://registry.npmjs.org/npm/-/npm-10.2.4.tgz: Connection reset
```

### Root Cause
- Network connectivity issues to NPM registry
- Firewall or proxy blocking NPM downloads
- Maven's frontend-maven-plugin trying to download Node/NPM

### Solutions

#### Option 1: Skip UI Build (Recommended for Backend Development)
```bash
# Compile Java code only
mvn clean compile -Dskip.ui=true

# Package without UI
mvn clean package -Dskip.ui=true

# Run application (UI won't be bundled, but backend works)
mvn spring-boot:run -Dspring-boot.run.profiles=local -Dskip.ui=true
```

#### Option 2: Build UI Separately
```bash
# Build backend without UI
mvn clean package -Dskip.ui=true

# In a separate terminal, build UI with Node directly
cd ui
npm install
npm run build

# UI will be built in ui/dist/
# Then copy to Spring Boot static resources
mkdir -p ../src/main/resources/static
cp -r dist/* ../src/main/resources/static/

# Now run the application
cd ..
mvn spring-boot:run -Dspring-boot.run.profiles=local -Dskip.ui=true
```

#### Option 3: Use Pre-installed Node/NPM
If you have Node.js installed locally:

```bash
# Install dependencies manually
cd ui
npm install
npm run build
cd ..

# Build Java project skipping frontend plugin
mvn clean package -Dskip.ui=true
```

#### Option 4: Configure Maven Proxy (If behind corporate firewall)
Add to `~/.m2/settings.xml`:

```xml
<settings>
  <proxies>
    <proxy>
      <id>http-proxy</id>
      <active>true</active>
      <protocol>http</protocol>
      <host>your-proxy-host</host>
      <port>8080</port>
    </proxy>
  </proxies>
</settings>
```

### For Development
For active development, the easiest approach is:

1. **Backend Development**: Use `-Dskip.ui=true` flag
2. **Frontend Development**: Run Vue dev server separately:
   ```bash
   # Terminal 1: Backend
   mvn spring-boot:run -Dspring-boot.run.profiles=local -Dskip.ui=true

   # Terminal 2: Frontend
   cd ui
   npm install  # Only once
   npm run dev  # Hot reload on http://localhost:5173
   ```

This gives you hot-reload for Vue and the API proxies to the backend.

---

## Docker Fixture Build Issues

### Problem
`./scripts/build-mcp-fixtures.sh` may fail if Docker is not running or git clone fails.

### Solution
```bash
# Ensure Docker is running
docker ps

# Build fixtures
./scripts/build-mcp-fixtures.sh

# If git clone fails, check network connectivity
# Or manually clone spring-ai-examples and build locally
```

---

## Testcontainers Issues

### Problem
Testcontainers may fail if Docker daemon is not accessible.

### Solution
```bash
# Ensure Docker is running
docker ps

# On macOS, ensure Docker Desktop is running
open -a Docker

# Testcontainers will automatically start Postgres
# Check logs if issues persist
```

---

## Default Admin Password

### Problem
Default admin password is hardcoded: `admin123`

### Solution
⚠️ **CRITICAL**: Change immediately in production!

For local development, it's fine. For cloud deployment:
```bash
# Update the password hash in schema.sql before deploying
# Or create a data migration script to update it
```

---

## Spring AI MCP 1.1.0-M3 Milestone Version

### Problem
Using a milestone version (not GA release) may have breaking changes.

### Mitigation
- Pin to specific milestone version: `1.1.0-M3`
- Monitor Spring AI releases for stable GA version
- Update documentation when GA is available

---

## JPA Schema Validation

### Problem
In `local` profile, `ddl-auto: create-drop` recreates schema on each restart.

### Behavior
- **Expected**: Database schema drops and recreates on each app start
- **Local dev**: This is intentional for clean state
- **Production**: Uses `ddl-auto: validate` in cloud profile

---

## UI Build in Maven Package Phase

### Problem
Full `mvn package` tries to build UI, which requires network access to NPM.

### Permanent Fix Options

**Option A: Default to Skip UI** (Recommended)
Update `pom.xml`:
```xml
<skip.ui>true</skip.ui>
```

Then explicitly enable UI build only when needed:
```bash
mvn clean package -Dskip.ui=false
```

**Option B: Use Maven Profiles**
Create separate profiles for UI/no-UI builds.

**Option C: Remove Frontend Plugin**
For backend-only development, comment out the frontend-maven-plugin entirely.

---

## Future Considerations

1. **Migration Tool**: Consider adding Flyway or Liquibase for schema migrations
2. **UI Build**: Move UI to separate repository or use CI/CD pipeline for UI builds
3. **MCP Fixtures**: Pin to specific commit SHA instead of `main` branch
4. **Secret Management**: Integrate with Vault or AWS Secrets Manager for production

---

## Getting Help

- **GitHub Issues**: https://github.com/dbbaskette/Nexus/issues
- **Documentation**: See [README.md](README.md)
- **Phase 0 Details**: See [PHASE0_COMPLETE.md](PHASE0_COMPLETE.md)
