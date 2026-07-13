#!/bin/bash

# Include utils
source ../utils/utils.sh

# This kata has no forge and no shared remote — the whole point is exchanging
# changes as plain files. We build two ordinary repos: the maintainer's project
# and your clone of it.

# Clean up any leftovers from a previous run.
rm -rf upstream exercise

# The maintainer's repository (a project that takes patches by email).
git -c init.defaultBranch="$DEFAULT_BRANCH" init -q upstream
cd upstream
git config commit.gpgsign false
cat > calc.py <<'EOF'
def add(a, b):
    return a + b
EOF
echo "# Calc — a tiny calculator" > README.md
git add calc.py README.md
git -c user.name="Maria Maintainer" -c user.email="maria@example.com" \
    commit -qm "Add calc with add()"
cd ..

# Your clone — you are the contributor. Your own git identity applies here, so
# the patches you produce will carry your name (that's the point).
git clone -q upstream exercise
cd exercise
git config commit.gpgsign false
