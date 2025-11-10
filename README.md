# Digital Garden

A living knowledge base for distributed systems, storage architecture, and infrastructure engineering.

🌐 **Live Site**: [digital-garden.atmy.casa](https://digital-garden.atmy.casa)

## Overview

This repository contains the source code for my personal digital garden, built with [MkDocs Material](https://squidfunk.github.io/mkdocs-material/). It features:

- 📝 **Blog**: Technical deep-dives and architecture breakdowns
- 📚 **Knowledge Base**: Curated reference material and documentation
- 🧭 **Principles**: Engineering principles and mental models
- 📓 **Journal**: Progress logs and learning notes

## Technology Stack

- **Generator**: [MkDocs](https://www.mkdocs.org/) with [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/)
- **Hosting**: GitHub Pages
- **Custom Domain**: `digital-garden.atmy.casa`
- **CI/CD**: GitHub Actions (automated deployment)

## Local Development

### Prerequisites

```bash
# Python 3.x required
python --version  # Should be 3.8+
```

### Setup

```bash
# Clone repository
git clone https://github.com/alfredojrc/digital-garden.git
cd digital-garden

# Install dependencies
pip install -r requirements.txt
```

### Development Server

```bash
# Start local server with live reload
mkdocs serve

# Server runs at http://127.0.0.1:8000
# Changes to docs/ or mkdocs.yml auto-reload
```

### Build

```bash
# Build static site to site/ directory
mkdocs build

# Build with strict mode (fails on warnings)
mkdocs build --strict
```

## Content Organization

```
docs/
├── index.md                 # Homepage
├── blog/                    # Blog with tags and categories
│   ├── .authors.yml        # Author profiles
│   ├── index.md            # Blog index
│   ├── tags.md             # Tag index
│   └── posts/              # Individual blog posts
├── kb/                      # Knowledge base
├── principles/              # Principles collection
├── journal/                 # Journal entries
└── stylesheets/
    └── extra.css           # Custom styling
```

## Writing Content

### Create a Blog Post

```bash
# Create new post in docs/blog/posts/
vim docs/blog/posts/my-new-post.md
```

**Post template**:
```markdown
---
date:
  created: 2025-11-10
authors:
  - alf
categories:
  - Storage
tags:
  - distributed-storage
  - performance
slug: my-new-post
---

# Post Title

Brief excerpt that appears in listings.

<!-- more -->

Full post content goes here...
```

### Categories and Tags

**Categories** (limited, non-overlapping):
- Storage
- Networking
- Architecture
- Infrastructure
- DevOps
- Security
- Performance

**Tags** (fine-grained, overlapping allowed):
- See `mkdocs.yml` for full list
- Add new tags by updating `tags_allowed` in config

## Deployment

Deployment is fully automated via GitHub Actions:

1. Push to `main` branch
2. GitHub Actions triggers workflow
3. MkDocs builds static site
4. Site deploys to `gh-pages` branch
5. GitHub Pages serves at custom domain

**Manual deployment** (if needed):
```bash
mkdocs gh-deploy --force
```

## Custom Domain Configuration

The site is configured to use `digital-garden.atmy.casa` via:

1. **CNAME file**: `docs/CNAME` contains the custom domain
2. **DNS records**: 4 A records pointing to GitHub Pages IPs
3. **GitHub settings**: Custom domain configured in repo settings

See deployment logs for verification.

## Features

### Blog Plugin
- Categories and tags for organization
- Archive by date
- Author profiles
- Read time estimation
- RSS feed integration

### Syntax Highlighting
- Dracula theme for code blocks
- Custom "console glow" effect
- Line numbers and copy buttons
- Mermaid diagram support

### Search
- Full-text search with suggestions
- Search highlighting
- Separator-aware indexing

### Navigation
- Sticky navigation tabs
- Instant page loading
- Integrated table of contents
- Back-to-top button

## Contributing

This is a personal knowledge base, but if you spot typos or have suggestions:

1. Open an issue
2. Submit a pull request
3. Start a discussion

## License

Content: [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)
Code: MIT

---

Built with ❤️ using [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/)
