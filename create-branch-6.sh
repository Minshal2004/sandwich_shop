#!/bin/sh
set -e

# Quick help
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  cat <<EOF
Usage:
  sh create-branch-6.sh         # run without needing +x
  ./create-branch-6.sh          # run if file is executable
  chmod +x create-branch-6.sh   # make executable (may require sudo)
If you get "permission denied" for chmod or executing:
  - Try: sh create-branch-6.sh
  - Or run the git command directly from the project root:
      git checkout -b 6
EOF
  exit 0
fi

# Ensure you're running this from the project root (the folder that contains .git)
if [ ! -d .git ]; then
  echo "No .git directory found. Run this from the project root that contains .git"
  echo
  echo "Run these commands from the project root instead:"
  echo "  sh create-branch-6.sh"
  echo "or directly:"
  echo "  git checkout -b 6"
  exit 1
fi

branch="6"

if git rev-parse --verify "$branch" >/dev/null 2>&1; then
  echo "Branch '$branch' already exists. Checking it out..."
  git checkout "$branch"
else
  echo "Creating and checking out branch '$branch'..."
  git checkout -b "$branch"
fi

echo "Now on branch: $(git rev-parse --abbrev-ref HEAD)"
