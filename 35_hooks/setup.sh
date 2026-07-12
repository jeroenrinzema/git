#!/bin/bash

# Include utils
source ../utils/utils.sh
kata="hooks"

make-exercise-repo

printf "def app():\n    return 1\n" > app.py
git add app.py
git commit -qm "Add app"
