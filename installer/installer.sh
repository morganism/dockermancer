#!/bin/bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
echo "Installing dockermancer gem..."
if command -v gem >/dev/null 2>&1; then
  gem install *.gem --local || gem install *.gem
else
  echo "RubyGems not found. Please install Ruby and rubygems."
  exit 1
fi

if [ -f payload/backup.tar.gz ]; then
  echo "Restoring backup..."
  dockermancer restore payload/backup.tar.gz
fi

echo "Done."
