# Remote SSH Authentication Guide

## Situation
You're on a remote server via SSH and cannot open a browser locally for OAuth authentication.

---

## Option 1: Personal Access Token (Easiest)

### Step 1: Generate Token on Your Local Machine

Visit this URL on your local computer's browser:
```
https://github.com/settings/tokens/new
```

Or navigate manually:
1. GitHub.com → Your profile icon (top right)
2. Settings → Developer settings (bottom of left sidebar)
3. Personal access tokens → Tokens (classic)
4. Generate new token → Generate new token (classic)

### Step 2: Configure Token

**Note description:** `digital-garden-deployment`

**Expiration:** 90 days (or your preference)

**Select scopes** (check these boxes):
- ✅ `repo` (Full control of private repositories)
  - This includes: `repo:status`, `repo_deployment`, `public_repo`, `repo:invite`, `security_events`
- ✅ `workflow` (Update GitHub Action workflows)
- ✅ `write:packages` (Upload packages to GitHub Package Registry)
- ✅ `delete:packages` (Delete packages from GitHub Package Registry)
- ✅ `admin:public_key` (Full control of user public keys)
- ✅ `admin:repo_hook` (Full control of repository hooks)

**Minimal scopes needed:**
- ✅ `repo` (required)
- ✅ `workflow` (required for GitHub Actions)

### Step 3: Copy the Token

After clicking "Generate token":
- GitHub shows your token **once**
- Copy it immediately (looks like: `ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`)
- **DO NOT CLOSE THE PAGE until you've used it below**

### Step 4: Authenticate on Remote Server

```bash
# Method A: Paste token when prompted
gh auth login --with-token
# (Paste your token and press Enter)

# Method B: Echo token directly (from local machine)
echo "ghp_YOUR_TOKEN_HERE" | gh auth login --with-token
```

### Step 5: Verify Authentication

```bash
gh auth status
```

Should show:
```
✓ Logged in to github.com as YOUR_USERNAME
✓ Token: ghp_************************************
```

### Step 6: Run Deployment

```bash
./deploy.sh
```

---

## Option 2: SSH Key Authentication (Alternative)

### Your SSH Public Key

Your server already has an SSH key. Here it is:

```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO/D3blfZripMwDfnc7eI5K5ZQ7qTAzQ7jvYOvy+s86v alf@godzilla.local
```

### Step 1: Add SSH Key to GitHub

Visit on your local machine:
```
https://github.com/settings/ssh/new
```

Or navigate:
1. GitHub.com → Settings
2. SSH and GPG keys (left sidebar)
3. New SSH key

**Title:** `digital-garden-server`

**Key:** Copy your SSH public key shown below and paste it

### Step 2: Authenticate gh CLI with SSH

```bash
# Choose GitHub.com
# Choose SSH protocol
# Use existing SSH key
gh auth login --git-protocol ssh
```

Then you'll see a device code flow (see Option 3 below).

---

## Option 3: Device Code Flow (No Token Needed)

This shows you a code to enter on GitHub.com

### Step 1: Start Authentication

```bash
gh auth login --web
```

Output will be:
```
! First copy your one-time code: XXXX-XXXX
Press Enter to open github.com in your browser...
```

### Step 2: Copy the Code

Copy the code shown (e.g., `A123-B456`)

### Step 3: Visit URL on Local Machine

Visit this URL on your local computer:
```
https://github.com/login/device
```

### Step 4: Enter Code

Paste the code from Step 1 and authorize the device.

### Step 5: Press Enter on Remote Server

After authorizing on GitHub, press Enter in your SSH session.

---

## Recommended Approach for Your Situation

**I recommend Option 1 (Personal Access Token)** because:
- ✅ Works immediately
- ✅ No browser interaction on remote server
- ✅ Can be done entirely from local machine
- ✅ Token can be revoked later
- ✅ Most straightforward

---

## Complete Workflow

### On Your Local Machine (with browser):

1. Go to: https://github.com/settings/tokens/new
2. Create token with `repo` + `workflow` scopes
3. Copy the token (starts with `ghp_`)

### On Remote Server (via SSH):

```bash
# Authenticate
echo "ghp_YOUR_TOKEN_HERE" | gh auth login --with-token

# Verify
gh auth status

# Deploy
./deploy.sh
```

That's it!

---

## Token Security Notes

- ✅ Token stored in: `~/.config/gh/hosts.yml`
- ✅ File permissions: 600 (only you can read)
- ✅ Token can be revoked anytime at: https://github.com/settings/tokens
- ⚠️ Don't commit tokens to git
- ⚠️ Don't share tokens
- ⚠️ Set expiration (recommend 90 days)

---

## Quick Command Reference

```bash
# Authenticate with token
echo "ghp_TOKEN" | gh auth login --with-token

# Check auth status
gh auth status

# Logout (if needed)
gh auth logout

# Run deployment
./deploy.sh

# Manual repo creation
gh repo create digital-garden --public --source=. --remote=origin --push
```

---

## Troubleshooting

### "Bad credentials" error
- Token expired or invalid
- Generate new token: https://github.com/settings/tokens/new

### "Permission denied" error
- Missing required scopes
- Regenerate token with `repo` + `workflow` scopes

### "Repository already exists"
- Use existing repository: `git remote add origin https://github.com/USERNAME/digital-garden.git`
- Or delete existing repo and recreate

---

## After Authentication

Once authenticated, the `deploy.sh` script will:
1. ✅ Detect authentication (no prompt)
2. ✅ Get your GitHub username
3. ✅ Create repository
4. ✅ Push code
5. ✅ Configure GitHub Pages
6. ✅ Set up custom domain
7. ✅ Monitor deployment

All automatic from there!

---

## Links You Need

**On your local machine, visit these:**

- Create token: https://github.com/settings/tokens/new
- Add SSH key: https://github.com/settings/ssh/new
- Device code: https://github.com/login/device
- View repos: https://github.com/YOUR_USERNAME?tab=repositories

---

Ready to authenticate? Choose your method above!
