#!/bin/bash

# Include utils
source ../utils/utils.sh
kata="fork-and-upstream"

rm -rf seed upstream fork

# The "upstream" project: the original repository you do not own.
git -c init.defaultBranch="$DEFAULT_BRANCH" init --bare upstream
git clone -q ./upstream seed
cd seed
echo "# Awesome Library" > README.md
git add README.md
git commit -qm "Add readme"
printf "def add(a, b):\n    return a + b\n" > lib.py
git add lib.py
git commit -qm "Add add()"
git push -q origin master
cd ..
rm -rf seed

# Your "fork": a server-side copy of upstream that you own (as GitHub's
# "Fork" button would create). It starts identical to upstream.
git clone -q --bare ./upstream fork

# Your local clone of YOUR fork. `origin` points at the fork.
git clone -q ./fork exercise
cd exercise

# Upstream then moves on without you: a maintainer merges a new feature.
cd ..
git clone -q ./upstream seed
cd seed
printf "def sub(a, b):\n    return a - b\n" >> lib.py
git commit -qam "Upstream: add sub()"
git push -q origin master
cd ..
rm -rf seed
cd exercise
