# Deployment Guide

## Current Status ✅

- ✅ Git repository initialized on `main` branch
- ✅ Initial commit created with all files
- ✅ DNS A records configured at Namecheap
- ✅ Custom domain ready: `digital-garden.atmy.casa`
- ⏳ **Next**: Push to GitHub and activate GitHub Pages

---

## Step 1: Create GitHub Repository

### Option A: Via GitHub Web Interface

1. Go to [github.com/new](https://github.com/new)
2. Fill in:
   - **Repository name**: `digital-garden`
   - **Description**: "Personal digital garden for distributed systems and infrastructure"
   - **Visibility**: **Public** (required for free GitHub Pages)
   - ⚠️ **DO NOT** check "Add a README file"
   - ⚠️ **DO NOT** check "Add .gitignore"
   - ⚠️ **DO NOT** choose a license
3. Click **"Create repository"**

### Option B: Via GitHub CLI (if installed)

```bash
gh repo create digital-garden --public --description "Personal digital garden for distributed systems and infrastructure" --source=. --remote=origin --push
```

---

## Step 2: Add Remote and Push

Replace `YOUR_GITHUB_USERNAME` with your actual GitHub username:

```bash
# Add remote origin
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/digital-garden.git

# Verify remote
git remote -v

# Push to GitHub
git push -u origin main
```

### If using SSH instead of HTTPS:

```bash
git remote add origin git@github.com:YOUR_GITHUB_USERNAME/digital-garden.git
git push -u origin main
```

---

## Step 3: Configure GitHub Pages

### 3.1 Enable GitHub Actions

1. Go to your repository on GitHub
2. Navigate to **Settings** → **Pages** (left sidebar)
3. Under **"Build and deployment"**:
   - **Source**: Select **"GitHub Actions"** from dropdown
   - This allows the workflow to deploy automatically

### 3.2 Wait for First Deployment

1. Go to **Actions** tab in your repository
2. You should see "Deploy MkDocs to GitHub Pages" workflow running
3. Wait ~2-3 minutes for completion
4. Look for green checkmark ✅

### 3.3 Configure Custom Domain

1. Still in **Settings** → **Pages**
2. Under **"Custom domain"**:
   - Enter: `digital-garden.atmy.casa`
   - Click **Save**
3. GitHub will check DNS configuration
4. This may take 5-60 minutes for DNS propagation
5. Once verified, a green checkmark appears with:
   ```
   ✓ DNS check successful
   ```

### 3.4 Enable HTTPS

1. After DNS verification completes
2. Check the box: **"Enforce HTTPS"**
3. GitHub automatically provisions SSL certificate (Let's Encrypt)
4. May take an additional 5-10 minutes

---

## Step 4: Verify Deployment

### Check GitHub Pages URL First

Your site will be available at:
```
https://YOUR_GITHUB_USERNAME.github.io/digital-garden/
```

Test this URL first to ensure deployment succeeded.

### Check Custom Domain

After DNS propagation (5-60 minutes):
```
https://digital-garden.atmy.casa
```

### Verification Checklist

- [ ] GitHub Actions workflow completed successfully
- [ ] Site loads at `username.github.io/digital-garden`
- [ ] Custom domain shows "DNS check successful" in settings
- [ ] HTTPS is enforced
- [ ] Site loads at `digital-garden.atmy.casa`
- [ ] Blog post appears with correct formatting
- [ ] Tags page loads
- [ ] Search functionality works
- [ ] Dark/light theme toggle works

---

## Troubleshooting

### Problem: DNS check failing

**Symptoms**:
- GitHub shows "DNS check failed" or "Improperly configured"

**Solution**:
1. Verify Namecheap A records are correct:
   ```
   Host: digital-garden | Value: 185.199.108.153
   Host: digital-garden | Value: 185.199.109.153
   Host: digital-garden | Value: 185.199.110.153
   Host: digital-garden | Value: 185.199.111.153
   ```
2. Check DNS propagation: `dig digital-garden.atmy.casa`
3. Wait longer (DNS can take up to 48 hours, typically 5-60 minutes)

### Problem: GitHub Actions failing

**Symptoms**:
- Red X on Actions tab
- Deployment workflow shows errors

**Solution**:
1. Click on failed workflow
2. Check error logs
3. Common issues:
   - Missing permissions: Ensure `contents: write` in workflow
   - Missing dependencies: Check requirements.txt
   - Branch mismatch: Ensure workflow triggers on `main` branch

### Problem: 404 on custom domain

**Symptoms**:
- `username.github.io/digital-garden` works
- `digital-garden.atmy.casa` shows 404

**Solution**:
1. Verify `docs/CNAME` file exists with `digital-garden.atmy.casa`
2. Check GitHub Pages settings show custom domain
3. Wait for DNS propagation
4. Clear browser cache
5. Try incognito/private browsing

### Problem: Site shows old content

**Symptoms**:
- Changes pushed but site not updating

**Solution**:
1. Check GitHub Actions completed successfully
2. Wait 2-5 minutes for CDN propagation
3. Hard refresh browser (Ctrl+Shift+R / Cmd+Shift+R)
4. Check `gh-pages` branch has latest commit

---

## DNS Configuration Reference

### Current Namecheap Setup

You've already configured these A records:

| Type | Host | Value | TTL |
|------|------|-------|-----|
| A Record | digital-garden | 185.199.108.153 | Automatic |
| A Record | digital-garden | 185.199.109.153 | Automatic |
| A Record | digital-garden | 185.199.110.153 | Automatic |
| A Record | digital-garden | 185.199.111.153 | Automatic |

### Verify DNS Propagation

```bash
# Check A records
dig digital-garden.atmy.casa +short

# Should return all 4 IPs:
# 185.199.108.153
# 185.199.109.153
# 185.199.110.153
# 185.199.111.153

# Check with specific DNS server
dig @8.8.8.8 digital-garden.atmy.casa +short
```

---

## Post-Deployment Workflow

### Adding New Content

```bash
# Create new blog post
vim docs/blog/posts/new-post.md

# Test locally (optional)
mkdocs serve

# Commit and push
git add docs/blog/posts/new-post.md
git commit -m "Add new post: [title]"
git push

# GitHub Actions automatically deploys (~2 minutes)
```

### Updating Configuration

```bash
# Edit site config
vim mkdocs.yml

# Test locally
mkdocs build --strict

# Commit and push
git add mkdocs.yml
git commit -m "Update site configuration"
git push
```

### Adding New Categories/Tags

Edit `mkdocs.yml`:
```yaml
plugins:
  - blog:
      categories_allowed:
        - Storage
        - Networking
        - YourNewCategory  # Add here

  - tags:
      tags_allowed:
        - pNFS
        - distributed-storage
        - your-new-tag  # Add here
```

Then commit and push.

---

## Quick Reference Commands

```bash
# Check repository status
git status

# See what changed
git diff

# Stage all changes
git add .

# Commit with message
git commit -m "Your message"

# Push to GitHub (triggers deployment)
git push

# View commit history
git log --oneline -10

# Check remote
git remote -v

# View deployment logs
# Go to: https://github.com/USERNAME/digital-garden/actions
```

---

## Expected Timeline

From push to live site:

| Stage | Duration | Status Check |
|-------|----------|--------------|
| **Push to GitHub** | Instant | `git push` completes |
| **Workflow starts** | 10-30 seconds | Actions tab shows "running" |
| **Build completes** | 1-2 minutes | Actions tab shows ✅ |
| **Deploy to gh-pages** | 10-20 seconds | Check gh-pages branch |
| **GitHub Pages CDN** | 1-2 minutes | Test username.github.io URL |
| **Custom domain DNS** | 5-60 minutes | Test custom domain URL |
| **HTTPS activation** | 5-10 minutes | HTTPS works without warnings |
| **Total (first time)** | **10-70 minutes** | Full propagation |
| **Subsequent deploys** | **3-5 minutes** | Updates only |

---

## What Happens Behind the Scenes

### On `git push`:

1. **GitHub receives commit**
   - Triggers workflow in `.github/workflows/deploy.yml`

2. **GitHub Actions runner spins up**
   - Ubuntu VM with Python 3.x
   - Installs dependencies from `requirements.txt`

3. **MkDocs builds site**
   - Reads `mkdocs.yml` configuration
   - Processes `docs/` directory
   - Generates static HTML/CSS/JS in `site/`
   - Applies Material theme and plugins

4. **Deploy to gh-pages branch**
   - Commits built site to `gh-pages` branch
   - Force pushes (replaces previous deployment)

5. **GitHub Pages serves site**
   - Detects `gh-pages` branch update
   - Syncs to CDN edge nodes globally
   - Serves at both GitHub URL and custom domain

### Files Created in gh-pages Branch:

```
gh-pages/
├── index.html                    # Homepage
├── blog/
│   ├── index.html               # Blog index
│   ├── posts/
│   │   └── 2025/11/10/
│   │       └── pnfs-distributed-storage-architecture/
│   │           └── index.html    # Your post
│   ├── tags/index.html          # Tag explorer
│   ├── category/
│   │   ├── storage/index.html   # Storage category
│   │   └── architecture/index.html
│   └── archive/index.html       # Date archive
├── kb/index.html
├── principles/index.html
├── journal/index.html
├── assets/
│   ├── stylesheets/
│   ├── javascripts/
│   └── images/
├── search/
│   └── search_index.json
└── CNAME                         # Custom domain pointer
```

---

## Support Resources

### Documentation
- [MkDocs Material Setup Guide](https://squidfunk.github.io/mkdocs-material/setup/)
- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [MkDocs Blog Plugin](https://squidfunk.github.io/mkdocs-material/plugins/blog/)

### Your Project Files
- **CLAUDE.md**: Guidance for future Claude Code sessions
- **README.md**: Project overview and development instructions
- **This file**: Deployment instructions

### Need Help?
1. Check GitHub Actions logs for deployment errors
2. Review MkDocs build output locally: `mkdocs build --strict`
3. Test DNS: `dig digital-garden.atmy.casa`
4. Open GitHub issue in your repository

---

## Security Notes

- ✅ Site is public (required for GitHub Pages)
- ✅ Source code is public in repository
- ✅ HTTPS enforced via Let's Encrypt
- ✅ No secrets or credentials in code
- ✅ GitHub Actions uses service account tokens
- ⚠️ Blog content is publicly accessible
- ⚠️ Git history is public (be careful with commits)

---

## Next Steps After Deployment

1. **Share your site**: `digital-garden.atmy.casa`
2. **Add more content**: Create additional blog posts
3. **Customize**: Update `docs/index.md` homepage
4. **Build KB**: Add knowledge base articles
5. **Monitor**: Watch GitHub Actions for successful deployments
6. **Iterate**: Write, commit, push, repeat!

---

**Ready to deploy?** Run the commands in Step 2 above with your GitHub username!
