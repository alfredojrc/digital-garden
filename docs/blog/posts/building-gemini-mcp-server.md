---
date:
  created: 2025-11-29
authors:
  - alf
categories:
  - AI
  - Architecture
  - DevOps
tags:
  - claude-code
  - mcp
  - gemini
  - ai-agents
  - docker
  - automation
  - llm
readtime: 15
slug: building-gemini-mcp-server
---

# Building a Gemini MCP Server: Integrating Google's AI with Claude Code

This post documents the architecture and implementation of a production-ready MCP (Model Context Protocol) server that wraps Google's Gemini CLI, enabling Claude Code to leverage Gemini as an adjacent AI for deep analysis, code review, and structured AI-to-AI debates.

<!-- more -->

## Why Combine Claude and Gemini?

Each AI model has unique strengths:

| Capability | Claude | Gemini |
|------------|--------|--------|
| **Context Window** | 200k tokens | 1M tokens |
| **Coding** | Excellent | Excellent |
| **Web Search** | Limited | Native Google Search |
| **Image Analysis** | Good | Excellent |
| **Reasoning** | Excellent | Excellent (Gemini 3 Pro) |

By integrating Gemini into Claude Code via MCP, you get the best of both worlds:

- **Claude** handles primary development workflow
- **Gemini** provides second opinions, large context analysis, and web research

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     Claude Code                                  │
│                         │                                        │
│                         ▼                                        │
│              ┌─────────────────────┐                            │
│              │    MCP Protocol     │                            │
│              └─────────────────────┘                            │
│                         │                                        │
│                         ▼                                        │
│    ┌─────────────────────────────────────────────────────────┐  │
│    │              gemini-mcp server (Docker)                  │  │
│    │  ┌────────────────────────────────────────────────────┐ │  │
│    │  │  FastMCP Server (Python)                           │ │  │
│    │  │  - 5 unified tools (v0.5.0)                        │ │  │
│    │  │  - HTTP transport (port 33020)                     │ │  │
│    │  │  - Health check endpoint                           │ │  │
│    │  └────────────────────────────────────────────────────┘ │  │
│    │                       │                                  │  │
│    │                       ▼                                  │  │
│    │  ┌────────────────────────────────────────────────────┐ │  │
│    │  │  Gemini CLI (Node.js)                              │ │  │
│    │  │  - OAuth authentication                            │ │  │
│    │  │  - Google Search grounding                         │ │  │
│    │  │  - Multiple model support                          │ │  │
│    │  └────────────────────────────────────────────────────┘ │  │
│    └─────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## Tool Consolidation: 44 → 5 Tools

Version 0.5.0 introduced a major token optimization by consolidating 44 individual tools into 5 unified tools:

| Tool | Purpose | Token Savings |
|------|---------|---------------|
| `gemini` | All AI query modes | 12 tools → 1 |
| `analyze` | Code/file/codebase analysis | 15 tools → 1 |
| `search` | Web and docs research | 6 tools → 1 |
| `debate` | AI-to-AI discussions | 6 tools → 1 |
| `trading` | Domain-specific analysis | 5 tools → 1 |

**Result**: ~93% token reduction (~29,000 → ~2,500 tokens)

### Tool 1: `gemini` - Unified AI Query

```python
async def gemini(
    prompt: str,
    mode: str = "fast",      # fast, reasoning, explain, summarize, models
    model: str = None,       # Override: gemini-3-pro-preview, gemini-2.5-flash
    context: str = "",
) -> dict | str:
```

**Mode options:**

| Mode | Model Used | Use Case |
|------|------------|----------|
| `fast` | gemini-2.5-flash | Quick questions, syntax help |
| `reasoning` | gemini-3-pro-preview | Complex analysis, architecture |
| `explain` | gemini-2.5-flash | Detailed explanations |
| `summarize` | gemini-2.5-flash | Bullet point summaries |
| `models` | N/A | List available models |

### Tool 2: `analyze` - Code Analysis

```python
async def analyze(
    target: str,             # File path, directory, code snippet, or git diff
    instruction: str,        # What to look for
    focus: str = "general",  # general, security, performance, architecture, patterns
) -> dict | str:
```

The tool automatically detects input type:

- **File path**: Reviews single file
- **Directory**: Analyzes entire codebase with 1M token context
- **Code snippet**: Inline code review
- **Git diff**: PR review with recommendations

### Tool 3: `search` - Web Research

```python
async def search(
    query: str,
    depth: str = "quick",       # quick, deep, academic, docs
    topic_context: str = None,
) -> dict:
```

**Depth options:**

| Depth | Description |
|-------|-------------|
| `quick` | Single web search |
| `deep` | Comprehensive multi-step research |
| `academic` | Academic papers, scholarly sources |
| `docs` | Library documentation lookup |

## Docker Configuration

### Multi-Stage Dockerfile

```dockerfile
FROM python:3.12-slim as builder

# Install Node.js 22 for Gemini CLI
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs

# Install Gemini CLI
RUN npm install -g @google/gemini-cli@nightly

# Install Python dependencies
COPY pyproject.toml .
RUN pip install --no-cache-dir .

FROM python:3.12-slim
COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin/gemini /usr/local/bin/gemini

# Run as non-root user
RUN useradd -m gemini
USER gemini

COPY src/gemini_mcp /app/gemini_mcp
WORKDIR /app

CMD ["python", "-m", "gemini_mcp.server"]
```

### Docker Compose

```yaml
services:
  gemini-mcp-http:
    build:
      context: .
      dockerfile: docker/Dockerfile
    container_name: gemini_mcp_http
    restart: unless-stopped
    ports:
      - "33020:8765"
    environment:
      - GEMINI_MCP_TRANSPORT=streamable-http
      - GEMINI_MCP_SERVER_HOST=0.0.0.0
      - GEMINI_MCP_SERVER_PORT=8765
      - GEMINI_MCP_GEMINI_DEFAULT_MODEL=gemini-3-pro-preview
      - GEMINI_MCP_GEMINI_TIMEOUT=300
      - GEMINI_MCP_GEMINI_ACTIVITY_TIMEOUT=1800
    volumes:
      # Mount OAuth credentials (read-only staging)
      - ${HOME}/.gemini:/home/gemini/.gemini-host:ro
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8765/health"]
      interval: 30s
      timeout: 10s
      retries: 3
```

## OAuth Authentication Strategy

Gemini CLI uses Google OAuth, not API keys. The container needs write access to refresh tokens, but we mount credentials read-only for security.

**Solution**: Copy-and-symlink strategy in entrypoint:

```bash
#!/bin/bash
# entrypoint.sh

# Copy credentials from read-only mount to writable location
cp -r /home/gemini/.gemini-host/* /home/gemini/.gemini-active/ 2>/dev/null || true

# Create symlink for Gemini CLI
ln -sf /home/gemini/.gemini-active /home/gemini/.gemini

# Run server
exec python -m gemini_mcp.server
```

## Streaming for Long Operations

Large codebase analysis can run for minutes. We use activity-based timeouts instead of fixed timeouts:

```python
class GeminiRequest:
    prompt: str
    stream: bool = False
    activity_timeout: int = 1800  # Reset on each event (30 min max between events)
```

**How it works:**

1. Use `--output-format stream-json` for real-time JSONL events
2. Events include: `init`, `message`, `tool_use`, `tool_result`, `result`
3. Activity timeout resets on each event received
4. Only times out if Gemini stops producing output for 30+ minutes

## Claude Code Integration

### HTTP Transport (Recommended)

Add to your Claude profile JSON:

```json
{
  "mcpServers": {
    "gemini-mcp": {
      "type": "http",
      "url": "http://localhost:33020/mcp"
    }
  }
}
```

### Stateless Mode for MCP Compatibility

Claude Code doesn't maintain session IDs between requests. Enable stateless HTTP:

```python
mcp = FastMCP(
    "gemini-mcp",
    host=config.server_host,
    port=config.server_port,
    stateless_http=True,   # Critical for Claude Code
    json_response=True,
)
```

## Health Check Endpoint

Custom HTTP endpoint for Docker/Kubernetes health probes:

```python
@mcp.custom_route("/health", methods=["GET"])
async def health_check(request: Request) -> JSONResponse:
    return JSONResponse({
        "status": "healthy",
        "service": "gemini-mcp",
        "version": "0.5.0",
        "tools_enabled": ["gemini", "analyze", "search", "debate", "trading"],
        "models": {
            "default": "gemini-3-pro-preview",
            "fast": "gemini-2.5-flash",
        },
    })
```

## Pricing: Flat Rate, Not Per-Token

**Critical distinction**: Gemini CLI uses Google AI subscription, not per-token API pricing.

| Tier | Price | Limits |
|------|-------|--------|
| Free (AI Studio) | $0/mo | Basic daily limits |
| Google AI Pro | $19.99/mo | Higher daily requests |
| Google AI Ultra | $149.99/mo | Highest limits (20x Pro) |

**Benefits:**

- Unlimited tokens per request (1M context window)
- Predictable costs
- No API key management
- All models included

## AI-to-AI Debates

The `debate` tool enables structured Claude-Gemini discussions:

```python
async def debate(
    topic: str,
    action: str = "start",        # start, list, stats, search, load, context
    strategy: str = "collaborative",  # collaborative, adversarial, socratic, devil_advocate
    context: str = "",
    debate_id: str = None,
) -> dict:
```

**Use cases:**

- Architectural decisions
- Strategy validation
- Risk assessment
- Design reviews

## Production Checklist

- [ ] Docker container running (`docker ps | grep gemini_mcp`)
- [ ] Health endpoint responding (`curl http://localhost:33020/health`)
- [ ] OAuth credentials mounted
- [ ] MCP configuration in Claude profile
- [ ] Systemd service enabled (optional)

## Conclusion

The Gemini MCP server transforms Claude Code into a dual-AI development environment. By leveraging Gemini's 1M token context, Google Search integration, and reasoning capabilities alongside Claude's excellent coding abilities, you get a more powerful development assistant.

The tool consolidation from 44 to 5 tools demonstrates how thoughtful API design can dramatically improve token efficiency while maintaining full functionality.

---

**Resources:**

- [Gemini CLI GitHub](https://github.com/google-gemini/gemini-cli)
- [MCP Protocol Specification](https://modelcontextprotocol.io)
- [FastMCP Documentation](https://github.com/jlowin/fastmcp)
- [Google AI Studio](https://aistudio.google.com)
