#!/bin/bash
source ../utils/utils.sh

# No remote, no network — that's the whole point. We build one source repo; you
# will move its history to a brand-new repo using only a file.
rm -rf project laptop ./*.bundle

git -c init.defaultBranch="$DEFAULT_BRANCH" init -q project
cd project
git config commit.gpgsign false
echo "# Field notes" > notes.md
git add notes.md
git -c user.name="git-katas trainer bot" -c user.email="git-katas@example.com" commit -qm "Start notes"
echo "- day 1: arrived" >> notes.md
git -c user.name="git-katas trainer bot" -c user.email="git-katas@example.com" commit -qam "Day 1"
echo "- day 2: explored" >> notes.md
git -c user.name="git-katas trainer bot" -c user.email="git-katas@example.com" commit -qam "Day 2"
cd ..
