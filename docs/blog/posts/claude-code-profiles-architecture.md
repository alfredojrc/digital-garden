---
date:
  created: 2025-11-29
authors:
  - alf
categories:
  - AI
  - CLI
  - Configuration
tags:
  - claude-code
  - mcp
  - ai-agents
  - automation
  - prompt-engineering
  - llm
  - context-management
readtime: 12
slug: claude-code-profiles-architecture
---

# Claude Code Profiles: Optimizing Token Usage with MCP Configurations

Claude Code's Model Context Protocol (MCP) enables powerful integrations with external tools, but loading all MCP servers simultaneously can consume 100k+ tokens of your context window. This post explores a profile-based architecture that optimizes token usage while maintaining full capabilities when needed.

<!-- more -->

## The Problem: Token Budget Management

When you configure Claude Code with multiple MCP servers, each server's tool definitions consume context tokens:

| MCP Server | Approximate Tokens |
|------------|-------------------|
| context7 | ~2,000 |
| magic (21st.dev) | ~3,000 |
| playwright | ~14,000 |
| claude-flow | ~57,000 |
| sequential-thinking | ~1,500 |
| qdrant | ~1,000 per collection |

Loading everything simultaneously can consume **100k+ tokens** before you even start working. This leaves limited space for your actual code context.

## The Solution: Profile-Based MCP Loading

Instead of a monolithic configuration, we create targeted profiles that load only the MCP servers needed for specific workflows:

```
~/.config/claude-profiles/
├── minimal.json      # ~2k tokens - General coding
├── design.json       # ~5k tokens - UI development
├── testing.json      # ~16k tokens - E2E testing
├── orchestration.json # ~57k tokens - Multi-agent swarms
└── pro.json          # ~60k tokens - Full workflow
```

### Profile 1: Minimal (Default)

For general coding, debugging, and file operations, you only need library documentation:

```json
{
  "mcpServers": {
    "context7": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    }
  }
}
```

**Token cost**: ~2,000
**Use cases**: Quick fixes, refactoring, debugging, code review

### Profile 2: Design

For UI development with React, Vue, or other frontend frameworks:

```json
{
  "mcpServers": {
    "context7": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    },
    "magic": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@21st-dev/magic@latest"]
    }
  }
}
```

**Token cost**: ~5,000
**Use cases**: UI components, design systems, accessibility, responsive design

### Profile 3: Testing

For browser automation and E2E testing:

```json
{
  "mcpServers": {
    "context7": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    },
    "playwright": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@playwright/mcp"]
    }
  }
}
```

**Token cost**: ~16,000
**Use cases**: E2E tests, visual testing, accessibility testing, browser automation

### Profile 4: Orchestration

For multi-agent swarm operations:

```json
{
  "mcpServers": {
    "context7": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    },
    "claude-flow": {
      "type": "stdio",
      "command": "npx",
      "args": ["claude-flow@alpha", "mcp", "start"]
    }
  }
}
```

**Token cost**: ~57,000
**Use cases**: Complex multi-step tasks, parallel agent execution, swarm intelligence

### Profile 5: Pro (Recommended for Complex Tasks)

The unified profile for full development workflows:

```json
{
  "mcpServers": {
    "context7": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    },
    "claude-flow": {
      "type": "stdio",
      "command": "npx",
      "args": ["claude-flow@alpha", "mcp", "start"]
    },
    "sequential-thinking": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    }
  }
}
```

**Token cost**: ~60,000
**Use cases**: Research → Implementation → Validation workflows

## Shell Aliases for Quick Access

Add these to your `~/.zshrc` or `~/.bashrc`:

```bash
# Claude Code Profiles
alias claude-minimal='claude --strict-mcp-config --mcp-config ~/.config/claude-profiles/minimal.json'

alias claude-design='claude --dangerously-skip-permissions --strict-mcp-config \
  --mcp-config ~/.config/claude-profiles/design.json \
  --append-system-prompt "UI/Design mode. Use magic for components, context7 for framework docs."'

alias claude-test='claude --dangerously-skip-permissions --strict-mcp-config \
  --mcp-config ~/.config/claude-profiles/testing.json \
  --append-system-prompt "Testing mode. Use playwright for browser automation."'

alias claude-swarm='claude --dangerously-skip-permissions --strict-mcp-config \
  --mcp-config ~/.config/claude-profiles/orchestration.json \
  --append-system-prompt "Swarm mode. Use claude-flow for multi-agent orchestration."'

alias claude-pro='claude --dangerously-skip-permissions --strict-mcp-config \
  --mcp-config ~/.config/claude-profiles/pro.json \
  --append-system-prompt "PRO MODE: Full development + orchestration capabilities."'
```

## Unified vs Split Workflow Architecture

### The Split Approach (Researcher → Operator)

Initially, we considered a two-phase workflow:

1. **Phase 1 (Researcher)**: Analysis and planning with research tools
2. **Phase 2 (Operator)**: Implementation with development tools

**Problem**: Context is lost during handoff. Bash command history, failed attempts, and reasoning chains don't transfer between sessions.

### The Unified Approach (Recommended)

A single `claude-pro` session maintains full context:

```
┌──────────────────────────────────────────────────────────────────────┐
│                    UNIFIED WORKFLOW (claude-pro)                      │
├──────────────────────────────────────────────────────────────────────┤
│  1. RESEARCH PHASE (in same session)                                 │
│     ├── Use context7 for library versions                            │
│     ├── Use sequential-thinking for analysis                         │
│     └── Store findings as you go                                     │
│                          │                                            │
│                          ▼                                            │
│  2. IMPLEMENTATION PHASE (same session, full context retained)       │
│     ├── Use claude-flow MCP tools for swarm orchestration           │
│     └── Context from research phase is FULLY AVAILABLE              │
│                          │                                            │
│                          ▼                                            │
│  3. VALIDATION PHASE (same session)                                  │
│     └── Document decisions for future reference                     │
└──────────────────────────────────────────────────────────────────────┘
```

### Why Unified Beats Split

| Aspect | Split Workflow | Unified Workflow |
|--------|---------------|------------------|
| **Context Continuity** | LOW - Lost at handoff | **HIGH** - Full chain of thought |
| **Token Efficiency** | 90k total, high startup x2 | **~60k** single context |
| **Complexity** | Managing 2 profiles, handoffs | **Simple** - one entry point |
| **Failed Attempts** | Lost during handoff | **Retained** - prevents repeating mistakes |

## Claude-Flow Self-Healing Wrapper

Claude-flow has a known bug where it can't find its `package.json`. Create a self-healing wrapper:

```bash
#!/bin/bash
# ~/.local/bin/cf - Claude-Flow wrapper with self-healing

# Pre-fetch/update claude-flow
npx --yes claude-flow@alpha --help >/dev/null 2>&1

# Find the most recent cache directory (macOS syntax)
LATEST_CACHE=$(find ~/.npm/_npx -type d -name "node_modules" \
  -path "*/claude-flow/*" -prune 2>/dev/null |
  xargs -I{} dirname {} 2>/dev/null |
  xargs -I{} stat -f '%m %N' {} 2>/dev/null |
  sort -rn | head -1 | cut -d' ' -f2-)

# Apply fix
if [ -d "$LATEST_CACHE/dist" ] && [ ! -e "$LATEST_CACHE/dist/package.json" ]; then
    ln -sf ../package.json "$LATEST_CACHE/dist/package.json" 2>/dev/null
fi

# Run claude-flow
exec npx claude-flow@alpha "$@"
```

Make it executable:

```bash
chmod +x ~/.local/bin/cf
```

## Current Tool Versions (November 2025)

| Tool | Version | Notes |
|------|---------|-------|
| claude-flow | v2.7.0-alpha.10 | Use `@alpha` tag |
| @upstash/context7-mcp | 1.0.30 | Latest stable |
| @playwright/mcp | Latest | Microsoft-maintained |
| @modelcontextprotocol/server-sequential-thinking | 2025.7.1 | Latest |
| mcp-server-qdrant | 0.6.0 | For knowledge bases |

## Best Practices

1. **Start Minimal**: Use `claude-minimal` for quick tasks
2. **Upgrade as Needed**: Switch to `claude-pro` for complex workflows
3. **Maintain Context**: Prefer unified sessions over split workflows
4. **Self-Heal**: Use wrapper scripts to handle tool quirks
5. **Document Decisions**: Store learnings for future reference

## Conclusion

Profile-based MCP loading transforms Claude Code from a resource-hungry behemoth into a nimble, context-efficient assistant. By matching your profile to your task, you preserve precious context tokens for actual work while maintaining access to powerful integrations when needed.

The unified `claude-pro` profile strikes the best balance for complex development workflows, retaining full context from research through implementation to validation.

---

**Resources:**

- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
- [claude-flow GitHub](https://github.com/ruvnet/claude-flow)
- [Context7 MCP](https://github.com/upstash/context7)
- [MCP Protocol Specification](https://modelcontextprotocol.io)
