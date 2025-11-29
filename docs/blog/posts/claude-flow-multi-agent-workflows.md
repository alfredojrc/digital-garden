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
  - ai-agents
  - multi-agent
  - swarm
  - automation
  - llm
readtime: 12
slug: claude-flow-multi-agent-workflows
---

# Multi-Agent AI Workflows with claude-flow

claude-flow enables orchestrated multi-agent swarms within Claude Code, allowing complex tasks to be broken down and executed in parallel by specialized agents. This post explores the architecture, practical patterns, and production configurations for AI-to-AI collaboration.

<!-- more -->

## What is claude-flow?

claude-flow is an MCP server that provides multi-agent orchestration capabilities to Claude Code. Instead of a single AI handling all tasks sequentially, claude-flow enables:

- **Parallel agent execution**: Multiple AI agents working simultaneously
- **Task decomposition**: Complex goals broken into specialized subtasks
- **Agent coordination**: Intelligent routing and result aggregation
- **Swarm intelligence**: Emergent capabilities from agent collaboration

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     Claude Code (Orchestrator)                   │
│                              │                                   │
│                              ▼                                   │
│              ┌─────────────────────────────┐                    │
│              │    claude-flow MCP Server    │                    │
│              │    (Swarm Coordinator)       │                    │
│              └─────────────────────────────┘                    │
│                              │                                   │
│          ┌───────────┬──────┴──────┬───────────┐               │
│          ▼           ▼             ▼           ▼               │
│    ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐        │
│    │ Agent 1  │ │ Agent 2  │ │ Agent 3  │ │ Agent N  │        │
│    │ Research │ │ Implement│ │ Test     │ │ Document │        │
│    └──────────┘ └──────────┘ └──────────┘ └──────────┘        │
│          │           │             │           │               │
│          └───────────┴──────┬──────┴───────────┘               │
│                             ▼                                   │
│              ┌─────────────────────────────┐                    │
│              │    Aggregated Results       │                    │
│              └─────────────────────────────┘                    │
└─────────────────────────────────────────────────────────────────┘
```

## Installation and Setup

### MCP Configuration

Add claude-flow to your Claude profile:

```json
{
  "mcpServers": {
    "claude-flow": {
      "type": "stdio",
      "command": "npx",
      "args": ["claude-flow@alpha", "mcp", "start"]
    }
  }
}
```

**Token cost**: ~57,000 tokens (use sparingly)

### Self-Healing Wrapper

claude-flow has a known bug where it can't locate its `package.json` in the npx cache. Create a wrapper script:

```bash
#!/bin/bash
# ~/.local/bin/cf - Claude-Flow wrapper with self-healing

# Pre-fetch/update claude-flow
npx --yes claude-flow@alpha --help >/dev/null 2>&1

# Find the most recent cache directory
# macOS syntax (use --format='%Y %n' for Linux)
LATEST_CACHE=$(find ~/.npm/_npx -type d -name "node_modules" \
  -path "*/claude-flow/*" -prune 2>/dev/null |
  xargs -I{} dirname {} 2>/dev/null |
  xargs -I{} stat -f '%m %N' {} 2>/dev/null |
  sort -rn | head -1 | cut -d' ' -f2-)

# Apply fix: symlink package.json to dist/
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

## Swarm Profiles

Different tasks require different swarm configurations. Here's a profile-based launcher:

```bash
#!/bin/bash
# ~/.local/bin/swarm - Profile-based swarm launcher

# Self-healing (same as cf wrapper)
npx --yes claude-flow@alpha --help >/dev/null 2>&1
LATEST_CACHE=$(find ~/.npm/_npx -type d -name "node_modules" \
  -path "*/claude-flow/*" -prune 2>/dev/null |
  xargs -I{} dirname {} 2>/dev/null |
  xargs -I{} stat -f '%m %N' {} 2>/dev/null |
  sort -rn | head -1 | cut -d' ' -f2-)
[ -d "$LATEST_CACHE/dist" ] && [ ! -e "$LATEST_CACHE/dist/package.json" ] && \
  ln -sf ../package.json "$LATEST_CACHE/dist/package.json" 2>/dev/null

# Parse profile
PROFILE="light"
case "$1" in
    light|test|full) PROFILE="$1"; shift ;;
esac

OBJECTIVE="$1"
shift

if [ -z "$OBJECTIVE" ]; then
    echo "Claude-Flow Swarm Launcher"
    echo ""
    echo "Usage: swarm [profile] \"objective\" [flags]"
    echo ""
    echo "Profiles:"
    echo "  light  - Essential tools (~5k tokens)"
    echo "  test   - Testing tools (~15k tokens)"
    echo "  full   - All tools (~60k tokens)"
    echo ""
    echo "Examples:"
    echo "  swarm \"Build REST API\"                   # Default light"
    echo "  swarm test \"Run E2E tests\" --parallel   # Testing"
    echo "  swarm full \"Architecture review\"         # Full"
    exit 0
fi

echo "[Swarm] Profile: $PROFILE | Objective: $OBJECTIVE"
export CLAUDE_FLOW_PROFILE="$PROFILE"
exec npx claude-flow@alpha swarm "$OBJECTIVE" "$@"
```

### Profile Token Budgets

| Profile | Token Cost | Use Case |
|---------|-----------|----------|
| `light` | ~5k | Quick coding tasks, simple refactoring |
| `test` | ~15k | Testing workflows with Playwright |
| `full` | ~60k | Complex research and implementation |

## Practical Workflow Patterns

### Pattern 1: Research → Implement → Validate

The most common workflow for feature development:

```bash
swarm full "Implement user authentication with JWT"
```

This spawns agents for:
1. **Research Agent**: Investigates best practices, security patterns
2. **Architecture Agent**: Designs component structure
3. **Implementation Agent**: Writes the actual code
4. **Testing Agent**: Creates and runs tests
5. **Documentation Agent**: Updates relevant docs

### Pattern 2: Parallel Code Review

For reviewing large PRs or codebases:

```bash
swarm full "Review authentication module for security vulnerabilities"
```

Agents focus on:
- Security patterns and OWASP compliance
- Performance bottlenecks
- Code quality and maintainability
- Test coverage gaps

### Pattern 3: Multi-File Refactoring

For coordinated changes across many files:

```bash
swarm light "Rename getUserData to fetchUserProfile across codebase"
```

Agents handle:
- Symbol detection and mapping
- Coordinated file edits
- Import statement updates
- Test fixture updates

## Shell Aliases

Add these to your `~/.zshrc` for quick access:

```bash
# ============================================================================
# Claude-Flow Shortcuts (self-healing wrappers)
# ============================================================================
alias cf='~/.local/bin/cf'                    # claude-flow with auto-fix
alias swarm='~/.local/bin/swarm'              # Profile-based swarm launcher
alias swarm-light='swarm light'               # Quick coding tasks
alias swarm-test='swarm test'                 # Testing with playwright
alias swarm-full='swarm full'                 # Full research mode
```

## Integration with Claude Code Profiles

claude-flow works best when combined with the appropriate Claude Code profile:

### Orchestration Profile

For swarm-heavy workflows:

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

### Pro Profile (Recommended)

For complete workflows with reasoning support:

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

## When to Use Swarms

### Good Use Cases

| Scenario | Swarm Profile | Why |
|----------|--------------|-----|
| Large feature implementation | `full` | Benefits from parallel research and implementation |
| Multi-file refactoring | `light` | Coordinated changes need agent synchronization |
| Security audits | `full` | Multiple specialized review perspectives |
| Test generation | `test` | Can parallelize across test categories |
| Documentation updates | `light` | Can update multiple docs simultaneously |

### When NOT to Use Swarms

| Scenario | Better Alternative |
|----------|-------------------|
| Simple bug fix | Direct Claude Code session |
| Single file edit | `claude-minimal` profile |
| Quick questions | No MCP needed |
| Small refactors (<3 files) | Standard edit tools |

**Rule of thumb**: Use swarms for tasks that would take >30 minutes to do sequentially.

## Resource Management

claude-flow is resource-intensive. Monitor your token usage:

### Token Budget Guidelines

| Total Context | Recommended Approach |
|--------------|---------------------|
| <50% used | Full swarm capabilities |
| 50-75% used | Light swarm profile only |
| >75% used | Avoid swarms, use direct edits |

### Efficiency Tips

1. **Start light**: Begin with `swarm-light`, escalate if needed
2. **Scope carefully**: Narrow objectives = faster completion
3. **Use checkpoints**: Save state for long operations
4. **Clean up**: Remove swarm artifacts when done

## Error Handling

### Common Issues

**Issue**: "Cannot find module '../package.json'"
```bash
# Solution: Use the self-healing wrapper
cf --version  # Instead of direct npx
```

**Issue**: Swarm hangs or times out
```bash
# Solution: Break into smaller objectives
swarm light "Step 1: Create data models"
swarm light "Step 2: Implement API endpoints"
swarm light "Step 3: Add authentication"
```

**Issue**: Agents produce conflicting changes
```bash
# Solution: Use sequential objectives or review before merge
swarm full "Review and merge agent proposals"
```

## Current Version Information

| Component | Version | Notes |
|-----------|---------|-------|
| claude-flow | v2.7.0-alpha.10 | Use `@alpha` tag |
| Claude Code | 2.0.42+ | Required for MCP support |
| Node.js | 18+ | Required for npx |

## Conclusion

claude-flow transforms Claude Code from a single-threaded assistant into a multi-agent development platform. By understanding when and how to deploy swarms, you can significantly accelerate complex development tasks while maintaining code quality.

The key is matching swarm profiles to task complexity: use `light` for quick coordination, `test` for quality assurance workflows, and `full` only when the research and implementation overhead is justified by the task scope.

---

**Resources:**

- [claude-flow GitHub](https://github.com/ruvnet/claude-flow)
- [MCP Protocol Specification](https://modelcontextprotocol.io)
- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
