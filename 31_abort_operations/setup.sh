#!/bin/bash

# Include utils
source ../utils/utils.sh
kata="abort-operations"

make-exercise-repo

printf "colour: blue\nsize: medium\n" > settings.txt
git add settings.txt
git commit -qm "Add settings"

# A branch that changes the SAME line as master will — guaranteeing a conflict
# whichever way you try to combine them.
git switch -qc experiment
printf "colour: green\nsize: medium\n" > settings.txt
git commit -qam "Experiment: change colour to green"

git switch -q master
printf "colour: red\nsize: medium\n" > settings.txt
git commit -qam "Change colour to red"
