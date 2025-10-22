#!/usr/bin/env bash
# Build Docker images for reference MCP fixture servers
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

SPRING_AI_EXAMPLES_REF="${SPRING_AI_EXAMPLES_REF:-main}"

echo "==> Building MCP fixture images from spring-ai-examples@${SPRING_AI_EXAMPLES_REF}"
echo ""

# Build all fixtures using docker-compose
docker-compose build \
  --build-arg SPRING_AI_EXAMPLES_REF="${SPRING_AI_EXAMPLES_REF}"

echo ""
echo "==> MCP fixture images built successfully:"
docker images --filter "reference=local/mcp-fixture-*:latest" --format "table {{.Repository}}:{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"

echo ""
echo "==> To start the fixture servers, run:"
echo "    docker-compose up -d"
