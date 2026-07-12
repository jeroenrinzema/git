#!/bin/bash

# Include utils
source ../utils/utils.sh
kata="rerere"

make-exercise-repo

printf "greeting = 'hello'\n" > app.py
git add app.py
git commit -qm "Add greeting"

# A long-lived topic branch that conflicts with master on the same line. You will
# resolve this conflict, throw the merge away, and hit the SAME conflict again —
# which is exactly where rerere saves you.
git switch -qc topic
printf "greeting = 'hej'\n" > app.py
git commit -qam "Topic: greeting in Danish"

git switch -q master
printf "greeting = 'hi'\n" > app.py
git commit -qam "Master: shorten greeting"
