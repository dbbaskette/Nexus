-- Nexus MCP Gateway Database Schema
-- PostgreSQL 16+

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================================================
-- Users and Authentication
-- =============================================================================

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    enabled BOOLEAN NOT NULL DEFAULT true,
    account_non_expired BOOLEAN NOT NULL DEFAULT true,
    account_non_locked BOOLEAN NOT NULL DEFAULT true,
    credentials_non_expired BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(255),
    updated_by VARCHAR(255)
);

CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);

-- Roles
CREATE TABLE roles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_roles_name ON roles(name);

-- User-Role mapping
CREATE TABLE user_roles (
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role_id UUID NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, role_id)
);

-- JWT Tokens (for revocation tracking)
CREATE TABLE tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_hash VARCHAR(255) UNIQUE NOT NULL,
    issued_at TIMESTAMP WITH TIME ZONE NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    revoked BOOLEAN NOT NULL DEFAULT false,
    revoked_at TIMESTAMP WITH TIME ZONE,
    revoked_reason VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_tokens_user_id ON tokens(user_id);
CREATE INDEX idx_tokens_token_hash ON tokens(token_hash);
CREATE INDEX idx_tokens_expires_at ON tokens(expires_at);

-- =============================================================================
-- MCP Server Registry
-- =============================================================================

CREATE TABLE mcp_servers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    base_url VARCHAR(1024),
    transport_type VARCHAR(50) NOT NULL, -- STDIO, SSE, STREAMABLE_HTTP
    enabled BOOLEAN NOT NULL DEFAULT true,
    health_status VARCHAR(50) NOT NULL DEFAULT 'UNKNOWN', -- HEALTHY, UNHEALTHY, UNKNOWN
    last_health_check TIMESTAMP WITH TIME ZONE,
    auth_type VARCHAR(50), -- NONE, BASIC, BEARER, CUSTOM
    auth_config JSONB, -- Encrypted credentials/config
    tags JSONB, -- Array of tags for filtering
    metadata JSONB, -- Additional custom metadata
    version INTEGER NOT NULL DEFAULT 0, -- Optimistic locking
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(255),
    updated_by VARCHAR(255)
);

CREATE INDEX idx_mcp_servers_name ON mcp_servers(name);
CREATE INDEX idx_mcp_servers_transport_type ON mcp_servers(transport_type);
CREATE INDEX idx_mcp_servers_enabled ON mcp_servers(enabled);
CREATE INDEX idx_mcp_servers_health_status ON mcp_servers(health_status);

-- =============================================================================
-- MCP Tools Cache
-- =============================================================================

CREATE TABLE mcp_tools (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    server_id UUID NOT NULL REFERENCES mcp_servers(id) ON DELETE CASCADE,
    tool_name VARCHAR(255) NOT NULL,
    description TEXT,
    input_schema JSONB, -- JSON Schema for tool inputs
    output_schema JSONB, -- JSON Schema for tool outputs
    last_synced_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    enabled BOOLEAN NOT NULL DEFAULT true,
    tags JSONB,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(server_id, tool_name)
);

CREATE INDEX idx_mcp_tools_server_id ON mcp_tools(server_id);
CREATE INDEX idx_mcp_tools_tool_name ON mcp_tools(tool_name);
CREATE INDEX idx_mcp_tools_enabled ON mcp_tools(enabled);

-- =============================================================================
-- Access Control Policies
-- =============================================================================

CREATE TABLE access_policies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    policy_type VARCHAR(50) NOT NULL, -- SERVER_ACCESS, TOOL_ACCESS
    resource_id UUID, -- References mcp_servers.id or mcp_tools.id
    resource_type VARCHAR(50) NOT NULL, -- SERVER, TOOL
    action VARCHAR(50) NOT NULL, -- READ, EXECUTE, ADMIN
    effect VARCHAR(50) NOT NULL DEFAULT 'ALLOW', -- ALLOW, DENY
    conditions JSONB, -- Additional conditions (IP range, time window, etc.)
    priority INTEGER NOT NULL DEFAULT 100,
    enabled BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(255),
    updated_by VARCHAR(255)
);

CREATE INDEX idx_access_policies_resource_id ON access_policies(resource_id);
CREATE INDEX idx_access_policies_resource_type ON access_policies(resource_type);
CREATE INDEX idx_access_policies_enabled ON access_policies(enabled);

-- Policy-Role mapping
CREATE TABLE policy_roles (
    policy_id UUID NOT NULL REFERENCES access_policies(id) ON DELETE CASCADE,
    role_id UUID NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    PRIMARY KEY (policy_id, role_id)
);

-- =============================================================================
-- Audit Logs
-- =============================================================================

CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    username VARCHAR(255),
    event_type VARCHAR(100) NOT NULL, -- AUTH, SERVER_REGISTER, TOOL_INVOKE, etc.
    resource_type VARCHAR(50), -- USER, SERVER, TOOL, POLICY
    resource_id UUID,
    action VARCHAR(50) NOT NULL, -- CREATE, READ, UPDATE, DELETE, EXECUTE
    status VARCHAR(50) NOT NULL, -- SUCCESS, FAILURE, DENIED
    client_ip VARCHAR(45),
    user_agent TEXT,
    correlation_id VARCHAR(255),
    request_data JSONB,
    response_data JSONB,
    error_message TEXT,
    duration_ms INTEGER
);

CREATE INDEX idx_audit_logs_timestamp ON audit_logs(timestamp DESC);
CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_event_type ON audit_logs(event_type);
CREATE INDEX idx_audit_logs_resource_type ON audit_logs(resource_type);
CREATE INDEX idx_audit_logs_status ON audit_logs(status);
CREATE INDEX idx_audit_logs_correlation_id ON audit_logs(correlation_id);

-- =============================================================================
-- Triggers for updated_at timestamps
-- =============================================================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_roles_updated_at BEFORE UPDATE ON roles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_mcp_servers_updated_at BEFORE UPDATE ON mcp_servers
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_mcp_tools_updated_at BEFORE UPDATE ON mcp_tools
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_access_policies_updated_at BEFORE UPDATE ON access_policies
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =============================================================================
-- Initial Data
-- =============================================================================

-- Insert default roles
INSERT INTO roles (name, description) VALUES
    ('ROLE_ADMIN', 'Administrator with full system access'),
    ('ROLE_OPERATOR', 'Operator with server management access'),
    ('ROLE_USER', 'Standard user with basic access');

-- Insert default admin user (password: admin123)
-- Note: Change this password in production!
INSERT INTO users (username, email, password_hash, created_by, updated_by) VALUES
    ('admin', 'admin@nexus.local', '$2a$10$5ZJy8EqKkF6PpLxEXKXPxeP3K1Oj6X7VZqYMJ5pMKlL5gXqZ5hZ5.', 'system', 'system');

-- Assign admin role to default admin user
INSERT INTO user_roles (user_id, role_id)
SELECT u.id, r.id FROM users u, roles r
WHERE u.username = 'admin' AND r.name = 'ROLE_ADMIN';
