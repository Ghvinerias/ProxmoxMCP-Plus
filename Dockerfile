# Use Python 3.11 slim image as base
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install mcpo uv

# Copy project files
COPY . .

# Create virtual environment and install dependencies
RUN uv venv && \
    . .venv/bin/activate && \
    uv pip install -e ".[dev]"

# Expose ports (8000 for SSE/STREAMABLE, 8811 for OpenAPI)
EXPOSE 8000 8811

# Set environment variables
ENV PROXMOX_MCP_CONFIG="/app/proxmox-config/config.json"

# Startup command - runs MCP server directly with SSE/STREAMABLE
CMD ["/bin/bash", "-c", "source .venv/bin/activate && python -m proxmox_mcp.server"]