# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A personal digital garden, knowledge base, and technical journal built with MkDocs Material, hosted at `digital-garden.atmy.casa` via GitHub Pages.

**Tech Stack**: Python MkDocs + mkdocs-material theme + GitHub Pages

## Development Commands

### Setup and Installation
```bash
# Install dependencies (first time setup)
pip install mkdocs mkdocs-material pymdown-extensions

# Or using requirements.txt if present
pip install -r requirements.txt
```

### Local Development
```bash
# Start local development server with live reload
mkdocs serve

# Server runs at http://127.0.0.1:8000
# Hot-reloads on file changes in docs/ or mkdocs.yml
```

### Building
```bash
# Build static site to site/ directory
mkdocs build

# Build with strict mode (fails on warnings)
mkdocs build --strict
```

### Deployment
Deployment is automated via GitHub Actions on push to `main` branch. The workflow builds and deploys to `gh-pages` branch.

Manual deployment (if needed):
```bash
mkdocs gh-deploy
```

## Architecture

### Content Organization
```
docs/                          # All content lives here
├── index.md                   # Homepage
├── kb/                        # Knowledge Base section
│   └── _index.md             # KB landing page
├── principles/                # Master principles collection
│   └── _index.md             # Principles landing page
├── journal/                   # Blog/log entries
│   ├── _index.md             # Journal landing page
│   └── *.md                  # Individual posts
└── stylesheets/
    └── extra.css             # Custom styling (console glow effects)
```

### Configuration Philosophy
- **Single source of truth**: `mkdocs.yml` defines all site structure, theme, navigation
- **Dark mode first**: Site defaults to slate (dark) theme with dracula syntax highlighting
- **Navigation via tabs**: Top-level sections (KB, Principles, Journal) appear as sticky tabs
- **Custom domain**: `CNAME` file in `docs/` points to `digital-garden.atmy.casa`

### Theme Customization
The site uses `mkdocs-material` with:
- **Palette**: Dark slate theme (primary: indigo, accent: cyan)
- **Syntax highlighting**: Dracula theme with console-style glow effect via custom CSS
- **Features**: Instant navigation, integrated TOC, search suggestions, code copy buttons
- **Branding**: Brain icon (material/brain) for logo and favicon

### Deployment Pipeline
1. Push to `main` branch triggers `.github/workflows/deploy.yml`
2. GitHub Action runs `mkdocs build`
3. Static site deployed to `gh-pages` branch
4. GitHub Pages serves from `gh-pages` at custom domain

### Key Files
- **mkdocs.yml**: Complete site configuration (theme, extensions, nav structure)
- **docs/CNAME**: Custom domain configuration for GitHub Pages
- **docs/stylesheets/extra.css**: Console glow effect for code blocks
- **.github/workflows/deploy.yml**: Automated deployment workflow

## Content Creation Patterns

### Adding New Content
1. Create `.md` file in appropriate section (`kb/`, `principles/`, `journal/`)
2. Add to `nav:` section in `mkdocs.yml` if explicit navigation needed
3. Use `_index.md` for section landing pages

### Markdown Extensions Available
- `pymdownx.highlight`: Syntax highlighting with line numbers
- `pymdownx.superfences`: Nested code blocks, diagrams
- `pymdownx.snippets`: Include external files
- `pymdownx.inlinehilite`: Inline code highlighting
- `admonition`: Callout boxes (note, warning, tip, etc.)
- `toc`: Auto-generated table of contents with permalinks

### Section Purposes
- **Knowledge Base (`kb/`)**: Reference material, technical notes, evergreen content
- **Principles (`principles/`)**: Curated principles, frameworks, mental models
- **Journal (`journal/`)**: Time-based entries, logs, progress updates

## DNS and Domain Configuration

**Custom Domain**: `digital-garden.atmy.casa`
- Managed via Namecheap DNS for `atmy.casa`
- Uses GitHub Pages A records (4x IPs: 185.199.108-111.153)
- Subdomain `digital-garden` points to GitHub Pages
- HTTPS enforced via GitHub Pages settings

## Important Notes

- All content must be in `docs/` directory to be included in build
- Navigation structure in `mkdocs.yml` must match actual file paths
- Custom CSS targets `.highlight` class from dracula pygments style
- GitHub Actions requires `gh-pages` branch to exist and be configured in repo settings
- DNS propagation can take 5-60 minutes after Namecheap configuration changes
