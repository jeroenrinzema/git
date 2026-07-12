#!/bin/bash

# Include utils
source ../utils/utils.sh
kata="stash"

make-exercise-repo

printf "def app():\n    return 1\n" > app.py
git add app.py
git commit -qm "Add app"
echo "# Project" > README.md
git add README.md
git commit -qm "Add readme"

# A branch where an urgent fix is needed.
git branch hotfix

# You are mid-change: a modified tracked file and a new untracked file.
printf "def app():\n    return 2  # work in progress\n" > app.py
echo "scratch notes, do not commit" > scratch.txt
