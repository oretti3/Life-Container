#!/bin/bash
set -e
umask 0002

echo "------------------------------------------------"
echo "🚀 Starting Life Container Initialization..."
echo "------------------------------------------------"

if [ -n "$GH_TOKEN" ]; then
    echo "🔑 GH_TOKEN detected."
    gh auth setup-git
    if gh auth status >/dev/null 2>&1; then
        CURRENT_USER=$(gh api user -q .login)
        echo "✅ Authenticated as: $CURRENT_USER"
        if [ -z "$GH_REPO" ]; then
            export GH_REPO="${CURRENT_USER}/Life-Container"
            echo "🔄 GH_REPO was not set. Auto-configured to: $GH_REPO"
        else
            echo "ℹ️  GH_REPO is explicitly set to: $GH_REPO"
        fi
        echo "🔍 Checking remote repository '$GH_REPO'..."
        if gh repo view "$GH_REPO" >/dev/null 2>&1; then
            echo "✅ Repository '$GH_REPO' found on GitHub."
        else
            echo "⚠️ Repository '$GH_REPO' does not exist."
            echo "🛠️ [Rescue] Creating private repository '$GH_REPO' automatically..."
            if gh repo create "$GH_REPO" --private --description "My Life Container powered by AI Agent" >/dev/null 2>&1; then
                echo "✅ Repository created successfully! (Private)"
            else
                echo "❌ Failed to create repository automatically."
                gh repo create "$GH_REPO" --private 2>&1 || true
            fi
        fi
    else
        echo "❌ Token seems invalid or expired."
        gh auth status
    fi
else
    echo "⚠️ GH_TOKEN is not set. Manual login required."
fi

if [ ! -d ".git" ]; then
    echo "📂 Workspace is not a git repository."
    
    if [ -n "$GH_REPO" ]; then
        echo "⬇️ Cloning $GH_REPO into current directory..."
        gh repo clone "$GH_REPO" . 2>/dev/null || echo "⚠️ Clone skipped: Directory not empty or repo not ready. (Run 'gh repo clone $GH_REPO .' manually if needed)"
    fi
else
    echo "✅ Workspace is already a git repository."
fi

echo "------------------------------------------------"
echo "✨ Initialization Complete."
echo "✨ Please pless d."
echo "✨ And run =docker compose exec life-agent bash="
echo "------------------------------------------------"
exec "$@"
