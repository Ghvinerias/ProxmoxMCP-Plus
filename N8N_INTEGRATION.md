# n8n Integration Guide for ProxmoxMCP-Plus

## Quick Start

### 1. Start the Server
```bash
./start_n8n_server.sh
```

The server will start on `0.0.0.0:8000` with SSE transport.

### 2. Test Connectivity
In another terminal:
```bash
python test_n8n_connection.py
```

### 3. Configure n8n

#### For SSE Transport (Recommended)
In n8n, add an MCP Server with these settings:

- **Transport**: SSE
- **URL**: `http://YOUR_SERVER_IP:8000/sse`
- **Name**: ProxmoxMCP-Plus

Replace `YOUR_SERVER_IP` with:
- `localhost` if n8n runs on same machine
- Your server's IP if n8n runs elsewhere
- `host.docker.internal` if n8n runs in Docker on same machine

#### For STREAMABLE Transport (Alternative)
Change config.json:
```json
"mcp": {
  "host": "0.0.0.0",
  "port": 8000,
  "transport": "STREAMABLE"
}
```

Then in n8n:
- **Transport**: HTTP/Streamable
- **URL**: `http://YOUR_SERVER_IP:8000/mcp/v1/`

## Troubleshooting

### Connection Refused
- Verify server is running: `curl http://localhost:8000/`
- Check firewall allows port 8000
- Ensure config has `"host": "0.0.0.0"`

### n8n Can't Find Tools
- Check server logs: `tail -f proxmox_mcp.log`
- Verify transport matches in config and n8n
- Test with: `python test_n8n_connection.py`

### Docker n8n
If n8n runs in Docker, use:
- `http://host.docker.internal:8000/sse` (Mac/Windows)
- `http://172.17.0.1:8000/sse` (Linux)

Or add to docker-compose:
```yaml
extra_hosts:
  - "host.docker.internal:host-gateway"
```

## Available Tools in n8n

Once connected, you'll have access to:
- VM Management (create, start, stop, delete)
- Container Management (LXC)
- Snapshot Management
- Backup/Restore
- ISO/Template Management
- Cluster Monitoring

## Testing Individual Tools

Example n8n workflow node:
```json
{
  "tool": "get_nodes",
  "parameters": {}
}
```

```json
{
  "tool": "get_vms",
  "parameters": {}
}
```

```json
{
  "tool": "start_vm",
  "parameters": {
    "node": "pve",
    "vmid": "101"
  }
}
```
