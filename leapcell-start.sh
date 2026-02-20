#!/bin/bash
set -e
# Create config directory
mkdir -p /tmp/.zeroclaw
# Generate config from environment variables
cat > /tmp/.zeroclaw/config.toml << EOF
api_key = "${API_KEY}"
default_provider = "${PROVIDER:-openrouter}"
default_model = "${MODEL:-anthropic/claude-3.5-sonnet}"
default_temperature = 0.7
[gateway]
port = ${PORT:-3000}
host = "0.0.0.0"
require_pairing = false
allow_public_bind = true
[memory]
backend = "postgres"
auto_save = true
[storage.provider.config]
provider = "postgres"
db_url = "${DATABASE_URL}"
schema = "public"
table = "memories"
connect_timeout_secs = 15
[autonomy]
level = "supervised"
workspace_only = false
[secrets]
encrypt = false
[runtime]
kind = "native"
EOF
# Set config directory via environment
export ZEROCLAW_CONFIG_DIR=/tmp/.zeroclaw
# Ensure the binary is executable
chmod +x ./target/release/zeroclaw
# Start gateway
echo "Starting ZeroClaw Gateway on port ${PORT}..."
exec ./target/release/zeroclaw gateway --port ${PORT:-3000} --host 0.0.0.0
