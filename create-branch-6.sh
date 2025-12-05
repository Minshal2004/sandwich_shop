#!/bin/sh
set -e

# Ensure you're running this from the project root (the folder that contains .git)
if [ ! -d .git ]; then
  echo "No .git directory found. Run this from the project root that contains .git"
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
