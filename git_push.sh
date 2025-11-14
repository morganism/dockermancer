#!/bin/bash
set -euo pipefail
if [ -z "${REMOTE_URL:-}" ]; then
  echo "Set REMOTE_URL to your git remote (e.g. git@github.com:user/repo.git)"
  exit 1
fi
git remote remove origin 2>/dev/null || true
git remote add origin "$REMOTE_URL"
git branch -M main
git push -u origin main
git push --tags
