#!/bin/bash

# This kata runs against a local Gitea server (a self-hosted GitHub-like forge)
# so you get a real pull-request UI. There is nothing to generate on disk here:
# the "remote" is the Gitea server, which you start from the README.
#
# It only checks that Docker is available and points you at the next step.

if ! command -v docker >/dev/null 2>&1; then
    echo "Docker is required for this kata but was not found on your PATH."
    echo "Install Docker Desktop (or OrbStack/Colima), then follow the README."
    return 2>/dev/null || exit 1
fi

echo "Docker found. Start the Gitea server with:"
echo ""
echo "    source ../utils/gitea/gitea.sh"
echo "    gitea-up"
echo ""
echo "Then follow the README from step 1."
