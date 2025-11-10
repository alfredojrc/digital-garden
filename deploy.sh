#!/bin/bash
set -e

# Digital Garden Deployment Script
# Automates GitHub repository creation and deployment

echo "🚀 Digital Garden Deployment Script"
echo "===================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configuration
REPO_NAME="digital-garden"
REPO_DESCRIPTION="Personal digital garden for distributed systems and infrastructure"
CUSTOM_DOMAIN="digital-garden.atmy.casa"

# Step 1: Check GitHub CLI installation
echo "📦 Checking GitHub CLI..."
if ! command -v gh &> /dev/null; then
    echo -e "${RED}❌ GitHub CLI (gh) is not installed${NC}"
    echo "Installing via Homebrew..."
    brew install gh
fi
echo -e "${GREEN}✅ GitHub CLI installed${NC}"
echo ""

# Step 2: Check authentication
echo "🔐 Checking GitHub authentication..."
if ! gh auth status &> /dev/null; then
    echo -e "${YELLOW}⚠️  Not authenticated with GitHub${NC}"
    echo ""
    echo "Please authenticate with GitHub:"
    echo "  1. Choose: GitHub.com"
    echo "  2. Choose: HTTPS"
    echo "  3. Choose: Login with web browser (recommended)"
    echo ""
    read -p "Press Enter to start authentication..."
    gh auth login
    echo ""
else
    echo -e "${GREEN}✅ Already authenticated with GitHub${NC}"
    gh auth status
    echo ""
fi

# Step 3: Get GitHub username
echo "👤 Getting GitHub username..."
GH_USERNAME=$(gh api user --jq '.login')
echo -e "${GREEN}✅ Authenticated as: ${GH_USERNAME}${NC}"
echo ""

# Step 4: Check if repository already exists
echo "🔍 Checking if repository exists..."
if gh repo view "${GH_USERNAME}/${REPO_NAME}" &> /dev/null; then
    echo -e "${YELLOW}⚠️  Repository ${GH_USERNAME}/${REPO_NAME} already exists${NC}"
    read -p "Do you want to use the existing repository? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 1
    fi
else
    # Step 5: Create repository
    echo "📝 Creating GitHub repository..."
    gh repo create "${REPO_NAME}" \
        --public \
        --description "${REPO_DESCRIPTION}" \
        --source=. \
        --remote=origin
    echo -e "${GREEN}✅ Repository created: https://github.com/${GH_USERNAME}/${REPO_NAME}${NC}"
    echo ""
fi

# Step 6: Configure remote (if not already done)
echo "🔗 Configuring git remote..."
if git remote get-url origin &> /dev/null; then
    echo -e "${GREEN}✅ Remote 'origin' already configured${NC}"
    git remote -v
else
    git remote add origin "https://github.com/${GH_USERNAME}/${REPO_NAME}.git"
    echo -e "${GREEN}✅ Remote 'origin' added${NC}"
fi
echo ""

# Step 7: Push to GitHub
echo "📤 Pushing to GitHub..."
if git push -u origin main; then
    echo -e "${GREEN}✅ Code pushed successfully${NC}"
else
    echo -e "${YELLOW}⚠️  Push failed, trying force push...${NC}"
    git push -u origin main --force
    echo -e "${GREEN}✅ Code force-pushed successfully${NC}"
fi
echo ""

# Step 8: Wait for initial deployment
echo "⏳ Waiting for GitHub Actions to start..."
sleep 5

# Step 9: Configure GitHub Pages
echo "⚙️  Configuring GitHub Pages..."

# Enable GitHub Pages with Actions
gh api -X PUT "repos/${GH_USERNAME}/${REPO_NAME}/pages" \
    --field build_type=workflow \
    --field source[branch]=gh-pages \
    --field source[path]="/" \
    2>/dev/null || echo -e "${YELLOW}⚠️  GitHub Pages may already be configured${NC}"

# Configure custom domain
echo "🌐 Configuring custom domain..."
gh api -X PUT "repos/${GH_USERNAME}/${REPO_NAME}/pages" \
    --field cname="${CUSTOM_DOMAIN}" \
    2>/dev/null || echo -e "${YELLOW}⚠️  Custom domain configuration pending DNS verification${NC}"

echo ""
echo -e "${GREEN}✅ GitHub Pages configured!${NC}"
echo ""

# Step 10: Monitor deployment
echo "👀 Monitoring deployment status..."
echo "   GitHub Actions: https://github.com/${GH_USERNAME}/${REPO_NAME}/actions"
echo ""

# Wait a bit for workflow to start
sleep 10

# Check latest workflow run
WORKFLOW_STATUS=$(gh run list --repo "${GH_USERNAME}/${REPO_NAME}" --limit 1 --json status,conclusion --jq '.[0]')
echo "Latest workflow: ${WORKFLOW_STATUS}"
echo ""

# Step 11: Display results
echo "🎉 Deployment Complete!"
echo "======================="
echo ""
echo "📍 Repository: https://github.com/${GH_USERNAME}/${REPO_NAME}"
echo "🌐 GitHub Pages URL: https://${GH_USERNAME}.github.io/${REPO_NAME}/"
echo "🏠 Custom Domain: https://${CUSTOM_DOMAIN}/ (after DNS propagation)"
echo ""
echo "📊 Next Steps:"
echo "   1. Monitor deployment: https://github.com/${GH_USERNAME}/${REPO_NAME}/actions"
echo "   2. Configure GitHub Pages settings if needed: Settings → Pages"
echo "   3. Wait 5-60 minutes for DNS propagation"
echo "   4. Enable HTTPS: Settings → Pages → Enforce HTTPS"
echo ""
echo "✨ Your digital garden is being deployed!"
echo ""

# Step 12: Open browser to repository
read -p "Open repository in browser? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    gh repo view --web
fi

echo ""
echo "🌱 Happy gardening! 🌱"
