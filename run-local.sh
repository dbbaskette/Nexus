#!/bin/bash
# Run Nexus Gateway locally with the 'local' profile
set -e

echo "🚀 Starting Nexus MCP Gateway (local profile)"
echo ""

# Check if mvn is available
if ! command -v mvn &> /dev/null; then
    echo "❌ Maven not found. Please install Maven first."
    exit 1
fi

# Check if UI should be built (default: skip)
SKIP_UI=${SKIP_UI:-true}

echo "ℹ️  UI Build: skipped (use SKIP_UI=false to build, or 'cd ui && npm run dev' for hot reload)"
echo ""

# Run with local profile, skipping UI build by default
mvn spring-boot:run -Dspring-boot.run.profiles=local -Dskip.ui=${SKIP_UI}
