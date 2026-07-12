#!/bin/bash

# Include utils
source ../utils/utils.sh
kata="force-with-lease"

rm -rf seed

# Shared remote with a main line of history.
make-bare-remote-repo
git clone -q ./remote seed
cd seed
echo "# Widget" > README.md
git add README.md
git commit -qm "Add readme"
git push -q origin master
cd ..
rm -rf seed

# Your clone, with a feature branch already pushed to the remote as three small,
# messy work-in-progress commits that you'll want to tidy up before review.
clone-remote-to-exercise
git switch -qc feature/widget
printf "def widget():\n    pass\n" > widget.py
git add widget.py
git commit -qm "wip"
printf "def widget():\n    return 1\n" > widget.py
git commit -qam "fix"
printf "def widget():\n    return 42\n" > widget.py
git commit -qam "actually works now"
git push -qu origin feature/widget
