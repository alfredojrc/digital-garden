# Digital Garden

> A living knowledge base for distributed systems, storage architecture, and infrastructure engineering

---

## 🗂️ Browse by Theme

<div class="grid cards" markdown>

-   :material-kubernetes: **Kubernetes CKA Mastery**

    ---

    Complete CKA certification prep with 22 comprehensive posts

    [Explore Kubernetes →](kubernetes/index.md)

-   :material-robot-outline: **AI & MCP Integration**

    ---

    Claude Code profiles, MCP servers, multi-agent swarms, AI-to-AI workflows

    [Explore AI →](/ai/)

-   :material-cloud: **Cloud Infrastructure**

    ---

    GCP, Azure, AWS, multi-cloud architectures

    [Explore Cloud →](/blog/)

-   :material-code-braces: **Infrastructure as Code**

    ---

    Terraform, Ansible, GitOps, automation

    [Explore IaC →](/blog/)

-   :material-server-network: **On-Premise Systems**

    ---

    Bare metal, datacenter, networking, storage

    [Explore On-Prem →](/blog/)

-   :material-shield-lock: **Cybersecurity**

    ---

    Security architecture, hardening, compliance

    [Explore Security →](/blog/)

-   :material-database: **Storage & Networking**

    ---

    File systems, protocols, high-performance I/O

    [Explore Storage →](/blog/)

</div>

---

## 📝 Latest Posts

[➡️ View All Posts](/blog/){ .md-button .md-button--primary }

### [Building a Home Lab Trading System](/blog/2025/12/24/building-home-lab-trading-system/)

**Architecture · Infrastructure** · 22 min read

A deep dive into building a personal cryptocurrency market intelligence system. Explores the "Split Brain" architecture with a home lab GPU for ML training and a Rust executor deployed to AWS Tokyo for low-latency execution. Covers microservices, real-time data processing, ONNX inference, and the experimental TamTam anomaly detection pipeline using Echo State Networks.

**Topics**: home-lab, rust, aws, machine-learning, trading, architecture

[Read more →](/blog/2025/12/24/building-home-lab-trading-system/){ .md-button }

### [AI-to-AI Debates and Multi-Agent Swarms](/blog/2025/12/11/gemini-mcp-debate-swarm-architecture/)

**AI · Architecture** · 25 min read

Deep dive into the debate system, swarm orchestration, voting mechanisms, and information flow patterns in the Gemini MCP architecture. Covers collaborative/adversarial/socratic debate strategies, dynamic agent spawning, confidence-weighted voting, and the Tool Bridge pattern for multi-agent coordination.

**Topics**: claude-code, mcp, gemini, ai-agents, multi-agent, swarm, llm

[Read more →](/blog/2025/12/11/gemini-mcp-debate-swarm-architecture/){ .md-button }

### [Multi-Agent AI Workflows with claude-flow](/blog/2025/11/29/claude-flow-multi-agent-workflows/)

**AI · Architecture** · 12 min read

claude-flow enables orchestrated multi-agent swarms within Claude Code, allowing complex tasks to be broken down and executed in parallel by specialized agents. Explore the architecture, practical patterns, and production configurations for AI-to-AI collaboration.

**Topics**: claude-code, mcp, ai-agents, multi-agent, swarm, automation

[Read more →](/blog/2025/11/29/claude-flow-multi-agent-workflows/){ .md-button }

### [Building a Gemini MCP Server](/blog/2025/11/29/building-gemini-mcp-server/)

**AI · Architecture · DevOps** · 15 min read

Architecture and implementation of a production-ready MCP server that wraps Google's Gemini CLI, enabling Claude Code to leverage Gemini as an adjacent AI for deep analysis, code review, and structured AI-to-AI debates. Features 93% token reduction through tool consolidation.

**Topics**: claude-code, mcp, gemini, ai-agents, docker, automation

[Read more →](/blog/2025/11/29/building-gemini-mcp-server/){ .md-button }

### [Claude Code Profiles: Optimizing Token Usage](/blog/2025/11/29/claude-code-profiles-architecture/)

**AI · CLI · Configuration** · 12 min read

Claude Code's MCP enables powerful integrations, but loading all servers can consume 100k+ tokens. This post explores a profile-based architecture that optimizes token usage while maintaining full capabilities when needed.

**Topics**: claude-code, mcp, ai-agents, context-management, prompt-engineering

[Read more →](/blog/2025/11/29/claude-code-profiles-architecture/){ .md-button }

### [kubectl Essentials: Your Kubernetes Swiss Army Knife](/blog/2025/11/11/kubectl-essentials/)

**Kubernetes** · 13 min read

Master kubectl commands, output formats, and productivity patterns essential for CKA exam success. Learn imperative vs declarative approaches, JSONPath queries, context management, and time-saving aliases for Kubernetes cluster management.

**Topics**: kubernetes, k8s, cka-prep, kubectl

[Read more →](/blog/2025/11/11/kubectl-essentials/){ .md-button }

### [Setting Up Your Kubernetes Lab Environment](/blog/2025/11/11/setting-up-kubernetes-lab/)

**Kubernetes · Infrastructure** · 12 min read

Complete guide to setting up Kubernetes lab environments for CKA preparation. Covers kubeadm cluster setup, Minikube for local development, kind for testing, kubectl installation, and kubeconfig management with practical examples.

**Topics**: kubernetes, k8s, cka-prep, kubeadm, kubectl, minikube

[Read more →](/blog/2025/11/11/setting-up-kubernetes-lab/){ .md-button }

### [Kubernetes Architecture Fundamentals](/blog/2025/11/11/kubernetes-architecture-fundamentals/)

**Kubernetes · Architecture** · 15 min read

Deep dive into Kubernetes cluster architecture, control plane components, and the distributed systems design that powers container orchestration at scale. Essential foundations for CKA certification with comprehensive diagrams, kubectl commands, and hands-on practice exercises.

**Topics**: kubernetes, k8s, cka-prep, architecture, control-plane, kubectl

[Read more →](/blog/2025/11/11/kubernetes-architecture-fundamentals/){ .md-button }

### [High-Performance pNFS v4.2 Distributed Storage Architecture](/blog/2025/11/10/pnfs-distributed-storage-architecture/)

**Storage · Architecture** · 12 min read

A deep dive into building a clustered, high-availability parallel NFS storage system with load-balanced metadata servers, NVMe-backed storage nodes, and low-latency interconnects. Features production-grade architecture with InfiniBand/RoCE fabrics, active-active MDS clustering, and parallel data paths achieving 28 GB/s aggregate throughput.

**Topics**: pNFS v4.2, distributed storage, NVMe, InfiniBand, RoCE, high availability, load balancing, metadata clustering

[Read more →](/blog/2025/11/10/pnfs-distributed-storage-architecture/){ .md-button }

---

## 🧭 Additional Resources

- **[Knowledge Base](kb/index.md)**: Curated reference material and evergreen documentation
- **[Principles](principles/index.md)**: Engineering principles and design patterns
- **[Journal](journal/index.md)**: Progress logs and learning notes
- **[Tags](/blog/tags/)**: Browse all content by tag

---

<small>This garden grows continuously · [Follow on GitHub](https://github.com/alfredojrc/digital-garden) · [RSS Feed](feed_rss_created.xml)</small>
