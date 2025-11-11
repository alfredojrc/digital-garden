# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A personal digital garden, knowledge base, and technical journal built with MkDocs Material, hosted at `digital-garden.atmy.casa` via GitHub Pages.

**Tech Stack**: Python MkDocs + mkdocs-material theme + blog plugin + GitHub Pages

**Active Content Series**:
- **Kubernetes CKA Mastery** (22-post comprehensive exam preparation series)
  - Status: 3/22 posts complete
  - Tracking: See [TODO.md](TODO.md) for detailed progress
  - Purpose: Complete Certified Kubernetes Administrator exam preparation
  - Structure: 7 phases covering 100% of CKA curriculum

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
├── index.md                   # Homepage (MANUAL post listings)
├── blog/                      # Blog managed by Material blog plugin
│   ├── index.md              # Auto-generated blog index (DO NOT EDIT)
│   ├── tags.md               # Tag browser page
│   ├── .authors.yml          # Author definitions
│   └── posts/                # ALL blog posts go here
│       ├── kubernetes-architecture-fundamentals.md
│       ├── kubernetes-lab-setup.md
│       ├── kubectl-essentials.md
│       └── pnfs-distributed-storage-architecture.md
├── kubernetes/                # Kubernetes CKA theme landing page
│   └── index.md              # Overview and navigation for 22-post series
├── kb/                        # Knowledge Base section
│   └── index.md              # KB landing page
├── principles/                # Master principles collection
│   └── index.md              # Principles landing page
├── journal/                   # Progress logs and updates
│   └── index.md              # Journal landing page
├── assets/
│   └── logos/
│       └── cactus.svg        # Site logo (dark mode support)
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

## Blog Architecture (CRITICAL)

### Blog Plugin Understanding
The site uses **Material for MkDocs blog plugin** which auto-generates blog functionality:

**CRITICAL RULES**:
1. **ALL blog posts MUST go in `docs/blog/posts/`** - No exceptions
2. **`docs/blog/index.md` is AUTO-GENERATED** - Never edit directly
3. **Homepage (`docs/index.md`) has MANUAL post listings** - Must update when adding posts
4. **Tags must be in `mkdocs.yml` → `tags_allowed`** - Build fails otherwise
5. **Categories must be in `mkdocs.yml` → `categories_allowed`** - Build fails otherwise

### Blog Post Front Matter (Required)
```yaml
---
date:
  created: YYYY-MM-DD       # Required
authors:
  - alf                     # Must match .authors.yml
categories:
  - CategoryName            # Must be in categories_allowed
tags:
  - tag-name                # Must be in tags_allowed
readtime: XX                # Minutes
slug: url-friendly-slug    # URL identifier
---

# Post Title

Excerpt text before the fold.

<!-- more -->

Full post content here...
```

### Adding New Blog Posts
1. Create `docs/blog/posts/your-post-name.md` with proper front matter
2. Add any new tags to `mkdocs.yml` → `plugins.blog.tags_allowed`
3. Add any new categories to `mkdocs.yml` → `plugins.blog.categories_allowed`
4. Update `docs/index.md` "Latest Posts" section manually
5. If new theme: Update `docs/index.md` "Browse by Theme" section
6. If series post: Update theme landing page (e.g., `docs/kubernetes/index.md`)
7. **VERIFY POST COMPLETENESS** (see checklist below)
8. Commit and push - GitHub Actions will deploy

### Post Verification Checklist (CRITICAL)

**Run this checklist BEFORE committing any blog posts to prevent deployment failures:**

#### 1. Excerpt Separator Check (MANDATORY)
```bash
# Verify ALL posts have the excerpt separator
for file in docs/blog/posts/*.md; do
  if ! grep -q "<!-- more -->" "$file"; then
    echo "❌ MISSING EXCERPT SEPARATOR: $file"
  fi
done
```
**Required**: Every post MUST have `<!-- more -->` after the excerpt.
**Location**: Place after 2-3 introductory paragraphs, before main content.
**Reason**: Blog plugin requires this for post excerpts. Build FAILS without it.

#### 2. Front Matter Validation
```bash
# Check front matter has all required fields
for file in docs/blog/posts/*.md; do
  echo "Checking $file..."
  grep -q "^date:" "$file" || echo "  ❌ Missing: date"
  grep -q "^  created:" "$file" || echo "  ❌ Missing: created date"
  grep -q "^authors:" "$file" || echo "  ❌ Missing: authors"
  grep -q "^categories:" "$file" || echo "  ❌ Missing: categories"
  grep -q "^tags:" "$file" || echo "  ❌ Missing: tags"
  grep -q "^readtime:" "$file" || echo "  ❌ Missing: readtime"
  grep -q "^slug:" "$file" || echo "  ❌ Missing: slug"
done
```

#### 3. Tags/Categories Validation
```bash
# Extract tags from post and verify against mkdocs.yml
# Manual check: Look at post tags, verify each exists in mkdocs.yml tags_allowed
# Manual check: Look at post categories, verify each exists in categories_allowed
```

#### 4. Local Build Test (if mkdocs installed)
```bash
# Test build locally before pushing
mkdocs build --strict

# If build succeeds, deployment will succeed
# If build fails, fix errors before pushing
```

#### 5. Quick Pre-Push Checklist
- [ ] Post has `<!-- more -->` excerpt separator
- [ ] Front matter has all required fields (date.created, authors, categories, tags, readtime, slug)
- [ ] All tags exist in `mkdocs.yml` → `tags_allowed`
- [ ] All categories exist in `mkdocs.yml` → `categories_allowed`
- [ ] Post filename follows convention: `topic-name.md` (lowercase, hyphens)
- [ ] Post is in `docs/blog/posts/` directory
- [ ] If part of series: Landing page link updated (e.g., `kubernetes/index.md`)

### Theme Landing Pages vs Blog Posts
- **Landing Pages** (e.g., `kubernetes/index.md`): Overview, navigation, series structure
- **Blog Posts** (e.g., `blog/posts/kubernetes-*.md`): Actual content, published posts
- Landing pages link TO blog posts, but don't contain the content themselves

### Common Errors & Solutions
**Error**: "Tags not in allow list: tag-name"
- **Fix**: Add `tag-name` to `mkdocs.yml` → `plugins.blog.tags_allowed`

**Error**: "category 'X' not in allow list"
- **Fix**: Add `X` to `mkdocs.yml` → `plugins.blog.categories_allowed`

**Error**: "Posts not appearing on homepage"
- **Fix**: Manually add post preview to `docs/index.md` "Latest Posts" section

**Error**: "Post doesn't appear in blog"
- **Fix**: Ensure post is in `docs/blog/posts/` (not elsewhere)

## Content Creation Patterns

### Adding New Content (Non-Blog)
1. Create `.md` file in appropriate section (`kb/`, `principles/`, `journal/`)
2. Add to `nav:` section in `mkdocs.yml` if explicit navigation needed
3. Use `index.md` for section landing pages

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
