#!/bin/bash
# Run Nexus Gateway locally with Testcontainers
set -e

echo "🚀 Starting Nexus MCP Gateway (local profile with Testcontainers)"
echo ""

# Check if mvn is available
if ! command -v mvn &> /dev/null; then
    echo "❌ Maven not found. Please install Maven first."
    exit 1
fi

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    echo "   Testcontainers requires Docker to start Postgres."
    exit 1
fi

# Check if UI should be built (default: skip)
SKIP_UI=${SKIP_UI:-true}

echo "ℹ️  UI Build: skipped (use SKIP_UI=false to build, or 'cd ui && npm run dev' for hot reload)"
echo "ℹ️  Testcontainers will auto-start Postgres in Docker"
echo ""

# Run TestNexusApplication which includes Testcontainers configuration
mvn spring-boot:test-run -Dskip.ui=${SKIP_UI}
