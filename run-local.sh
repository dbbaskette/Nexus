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

# Run with local profile
mvn spring-boot:run -Dspring-boot.run.profiles=local
