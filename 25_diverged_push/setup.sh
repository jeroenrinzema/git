#!/bin/bash

# Include utils
source ../utils/utils.sh
kata="diverged-push"

rm -rf seed

# Shared remote with some starting history.
make-bare-remote-repo
git clone -q ./remote seed
cd seed
echo "# Recipes" > README.md
git add README.md
git commit -qm "Add readme"
printf "1. Boil water\n" > recipe.txt
git add recipe.txt
git commit -qm "Add first recipe step"
git push -q origin master
cd ..
rm -rf seed

# Your clone (you start here).
clone-remote-to-exercise

# A teammate pushes a NEW commit to the remote *after* you cloned. It touches a
# different file than you will, so the histories diverge but do NOT conflict —
# resolving conflicts is the next kata's job. You won't know about this commit
# until you fetch, which is exactly what causes a diverged push.
cd ..
git clone -q ./remote seed
cd seed
printf "A collection of simple recipes.\n" >> README.md
git commit -qam "Teammate: describe the project"
git push -q origin master
cd ..
rm -rf seed
cd exercise
