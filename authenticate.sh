#!/bin/bash

# GitHub Authentication Helper for Remote SSH Sessions
# This script helps you authenticate when you're on a remote server

echo "🔐 GitHub Authentication for Remote SSH"
echo "========================================="
echo ""

# Check if already authenticated
if gh auth status &> /dev/null; then
    echo "✅ Already authenticated!"
    gh auth status
    echo ""
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

echo "Choose authentication method:"
echo ""
echo "1) Personal Access Token (Easiest)"
echo "   - Visit GitHub on your local machine"
echo "   - Create a token"
echo "   - Paste it here"
echo ""
echo "2) Device Code Flow (Secure)"
echo "   - Get a code here"
echo "   - Visit GitHub on your local machine"
echo "   - Enter the code"
echo ""
echo "3) SSH Key (Advanced)"
echo "   - Add your SSH key to GitHub"
echo "   - Use SSH authentication"
echo ""

read -p "Select method (1, 2, or 3): " -n 1 -r
echo ""
echo ""

case $REPLY in
    1)
        echo "📝 Personal Access Token Method"
        echo "================================"
        echo ""
        echo "Step 1: On your LOCAL COMPUTER, open this URL in a browser:"
        echo ""
        echo "   🔗 https://github.com/settings/tokens/new?description=digital-garden&scopes=repo,workflow,read:org"
        echo ""
        echo "Step 2: Click 'Generate token' at the bottom"
        echo ""
        echo "Step 3: Copy the token (starts with ghp_)"
        echo ""
        echo "Step 4: Paste it here:"
        echo ""

        # Read token securely
        read -s -p "Token: " TOKEN
        echo ""
        echo ""

        # Authenticate
        echo "🔐 Authenticating..."
        echo "$TOKEN" | gh auth login --with-token

        if gh auth status &> /dev/null; then
            echo ""
            echo "✅ Authentication successful!"
            gh auth status
            echo ""
            echo "🚀 Ready to deploy! Run: ./deploy.sh"
        else
            echo ""
            echo "❌ Authentication failed. Please check your token."
            exit 1
        fi
        ;;

    2)
        echo "📱 Device Code Flow Method"
        echo "=========================="
        echo ""
        echo "Starting device code authentication..."
        echo ""

        # This will show a code and URL
        gh auth login --git-protocol https --web

        if gh auth status &> /dev/null; then
            echo ""
            echo "✅ Authentication successful!"
            gh auth status
            echo ""
            echo "🚀 Ready to deploy! Run: ./deploy.sh"
        else
            echo ""
            echo "❌ Authentication failed."
            exit 1
        fi
        ;;

    3)
        echo "🔑 SSH Key Method"
        echo "================="
        echo ""
        echo "Your SSH public key:"
        echo ""
        cat ~/.ssh/id_ed25519.pub
        echo ""
        echo "Step 1: On your LOCAL COMPUTER, open this URL:"
        echo ""
        echo "   🔗 https://github.com/settings/ssh/new"
        echo ""
        echo "Step 2: Paste the SSH key above"
        echo ""
        echo "Step 3: Give it a title like 'digital-garden-server'"
        echo ""
        read -p "Press Enter after adding the key to GitHub..."
        echo ""

        # Test SSH connection
        echo "Testing SSH connection..."
        if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
            echo "✅ SSH connection successful!"
            echo ""

            # Configure gh to use SSH
            gh auth login --git-protocol ssh

            if gh auth status &> /dev/null; then
                echo ""
                echo "✅ Authentication successful!"
                gh auth status
                echo ""
                echo "🚀 Ready to deploy! Run: ./deploy.sh"
            fi
        else
            echo "❌ SSH connection failed. Please verify the key was added correctly."
            echo ""
            echo "Visit: https://github.com/settings/keys"
            exit 1
        fi
        ;;

    *)
        echo "Invalid selection. Exiting."
        exit 1
        ;;
esac

echo ""
echo "════════════════════════════════════════"
echo "Next step: Run the deployment script"
echo ""
echo "  ./deploy.sh"
echo ""
echo "════════════════════════════════════════"
