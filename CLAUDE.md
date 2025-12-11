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
- **AI & MCP Integration** (4-post series on Claude Code tooling)
  - Claude Code Profiles: Token-optimized MCP configurations
  - Building a Gemini MCP Server: AI-to-AI integration
  - Multi-Agent Workflows with claude-flow: Swarm orchestration
  - AI-to-AI Debates and Multi-Agent Swarms: Debate systems, voting, orchestration
  - **Landing Page**: `docs/ai/index.md` (UPDATE when adding AI posts!)

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
├── home.md                    # Homepage at /home/ (MANUAL post listings)
├── blog/                      # Blog managed by Material blog plugin
│   ├── index.md              # Auto-generated blog index (DO NOT EDIT)
│   ├── tags.md               # Tag browser page
│   ├── .authors.yml          # Author definitions
│   └── posts/                # ALL blog posts go here
│       ├── kubernetes-architecture-fundamentals.md
│       ├── kubernetes-lab-setup.md
│       ├── kubectl-essentials.md
│       ├── pnfs-distributed-storage-architecture.md
│       ├── claude-code-profiles-architecture.md      # AI series
│       ├── building-gemini-mcp-server.md             # AI series
│       ├── claude-flow-multi-agent-workflows.md      # AI series
│       └── gemini-mcp-debate-swarm-architecture.md   # AI series
├── themes/                    # By Theme section landing page
│   └── index.md              # SECTION INDEX - lists all themes (REQUIRED!)
├── ai/                        # AI theme landing page
│   └── index.md              # Overview for AI series (UPDATE when adding AI posts!)
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

### Navigation Section Indexes (CRITICAL)

With `navigation.indexes` enabled in mkdocs.yml, nav sections need their own index pages:

**The Problem**: Without a section index, clicking "By Theme" navigates to the first child item, but the sidebar shows the parent label instead of the child label.

**The Solution**: Every nav section with children MUST have its own index.md:

```yaml
# ✅ CORRECT - Section has its own index
- By Theme:
    - themes/index.md              # Section index (first item, no label = uses section title)
    - AI & MCP Integration: ai/index.md
    - Kubernetes CKA Mastery: kubernetes/index.md

# ❌ WRONG - No section index causes label display issues
- By Theme:
    - AI & MCP Integration: ai/index.md
    - Kubernetes CKA Mastery: kubernetes/index.md
```

**When Adding New Nav Sections**:
1. Create a section index page: `docs/section-name/index.md`
2. Add it as the FIRST item under the section (without a label)
3. Add child items with their labels

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
3. **Homepage (`docs/home.md`) has MANUAL post listings** - Must update when adding posts
4. **Tags must be in `mkdocs.yml` → `tags_allowed`** - Build fails otherwise
5. **Categories must be in `mkdocs.yml` → `categories_allowed`** - Build fails otherwise
6. **USE ABSOLUTE PATHS for cross-section links** - See URL Rules below

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
social_image: assets/images/blog/custom-image.jpg  # Optional: custom social preview
---

# Post Title

Excerpt text before the fold.

<!-- more -->

Full post content here...
```

### Social Media Preview Images (LinkedIn, Twitter, etc.)

The site uses Open Graph meta tags for social media previews. Configuration is in `overrides/main.html`.

**Default behavior**: All pages use `assets/social-card.png` (cactus logo)

**Custom per-post image**: Add `social_image` to front matter:
```yaml
social_image: assets/images/blog/your-custom-image.jpg
```

#### LinkedIn Image Requirements (CRITICAL)

LinkedIn is strict about image dimensions. Images that don't meet requirements will NOT display.

| Requirement | Value | Notes |
|-------------|-------|-------|
| **Minimum dimensions** | 1200 x 627 px | MUST meet both width AND height |
| **Recommended ratio** | 1.91:1 | Exactly 1200x627 or proportional |
| **Maximum file size** | 5 MB | Keep under 1MB for fast loading |
| **Format** | JPEG, PNG | JPEG recommended for photos |
| **Color mode** | RGB | Not CMYK |

**Common issue**: Images smaller than 1200x627 will show as tiny thumbnails or not at all!

#### Creating LinkedIn-Compatible Images

```bash
# Verify image meets LinkedIn requirements
python3 << 'EOF'
from PIL import Image
import os
img_path = 'docs/assets/images/blog/your-image.jpg'
img = Image.open(img_path)
size_mb = os.path.getsize(img_path) / (1024 * 1024)
print(f"Dimensions: {img.width}x{img.height}")
print(f"✅ Width >= 1200: {img.width >= 1200}")
print(f"✅ Height >= 627: {img.height >= 627}")
print(f"✅ Size < 5MB: {size_mb:.2f}MB")
EOF

# Resize image to LinkedIn specs (if needed)
python3 << 'EOF'
from PIL import Image
img = Image.open('input.jpg')
# Scale to 1200 width, maintaining aspect ratio
scale = 1200 / img.width
new_size = (1200, int(img.height * scale))
img_resized = img.resize(new_size, Image.Resampling.LANCZOS)
# If height < 627, add dark padding
if img_resized.height < 627:
    canvas = Image.new('RGB', (1200, 627), (15, 23, 42))
    y_offset = (627 - img_resized.height) // 2
    canvas.paste(img_resized, (0, y_offset))
    canvas.save('output.jpg', quality=95)
else:
    img_resized.save('output.jpg', quality=95)
EOF
```

#### Testing Social Previews

1. **LinkedIn Post Inspector**: https://www.linkedin.com/post-inspector/
   - Enter URL, click "Inspect"
   - Forces cache refresh
   - Shows preview and any errors

2. **Verify OG tags in HTML**:
```bash
curl -s "https://digital-garden.atmy.casa/blog/..." | grep "og:image"
```

#### File Locations

```
docs/assets/
├── social-card.png              # Default (1200x630, cactus logo)
└── images/blog/
    └── custom-post-image.jpg    # Per-post custom images
```

### Adding New Blog Posts
1. Create `docs/blog/posts/your-post-name.md` with proper front matter
2. Add any new tags to `mkdocs.yml` → `plugins.blog.tags_allowed`
3. Add any new categories to `mkdocs.yml` → `plugins.blog.categories_allowed`
4. Update `docs/home.md` "Latest Posts" section manually (USE ABSOLUTE PATHS!)
5. If new theme: Update `docs/home.md` "Browse by Theme" section
6. **If part of a series: Update the theme landing page** (CRITICAL - often forgotten!)
   - AI series → Update `docs/ai/index.md` with new post entry
   - Kubernetes series → Update `docs/kubernetes/index.md` with new post entry
   - Include: Title, link, description, key topics, tags
   - Update "Last Updated" date and "Total Posts" count
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
- [ ] **If part of series: Theme landing page updated** (e.g., `ai/index.md`, `kubernetes/index.md`)
  - [ ] New post entry added with title, link, description, key topics, tags
  - [ ] "Last Updated" date updated
  - [ ] "Total Posts" count incremented
- [ ] **Homepage links use ABSOLUTE paths** (`/blog/...` not `blog/...`)

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
- **Fix**: Manually add post preview to `docs/home.md` "Latest Posts" section

**Error**: "Post doesn't appear in blog"
- **Fix**: Ensure post is in `docs/blog/posts/` (not elsewhere)

**Error**: "Links lead to 404 pages (e.g., /home/blog/...)"
- **Cause**: Using relative paths (`blog/...`) from pages not at root
- **Fix**: Use absolute paths starting with `/` (e.g., `/blog/2025/11/29/slug/`)

### URL Path Rules (CRITICAL)

**Problem**: `home.md` renders at `/home/`. Relative links like `blog/...` resolve to `/home/blog/...` = 404!

**Rule**: Always use **absolute paths** for cross-section links:
```markdown
# ❌ WRONG - Relative paths break from non-root pages
[Read more →](blog/2025/11/29/post-slug/)

# ✅ CORRECT - Absolute paths always work
[Read more →](/blog/2025/11/29/post-slug/)
```

**Where this applies**:
- `docs/home.md` → Use `/blog/...`, `/kubernetes/...`, `/kb/...`
- `docs/kubernetes/index.md` → Use `/blog/...` for post links
- Any page not at the site root

**Safe relative paths** (within same section):
- From `blog/posts/foo.md` to `../tags.md` → OK (same section)
- From `kubernetes/index.md` to `../home.md` → OK (going up)

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
