#!/bin/bash
set -e
# Create config directory
mkdir -p /tmp/.zeroclaw
# Generate config from environment variables
cat > /tmp/.zeroclaw/config.toml << EOF
api_key = "${API_KEY}"
default_provider = "openrouter"
default_model = "openrouter/free"
default_temperature = 0.7
[gateway]
port = ${PORT:-3000}
host = "0.0.0.0"
require_pairing = false
allow_public_bind = true
[memory]
backend = "sqlite"
auto_save = true
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
# Start gateway
echo "Starting ZeroClaw Gateway on port ${PORT}..."
exec ./target/release/zeroclaw gateway --port ${PORT:-3000} --host 0.0.0.0
