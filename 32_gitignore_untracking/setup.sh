#!/bin/bash

# Include utils
source ../utils/utils.sh
kata="gitignore-untracking"

make-exercise-repo

printf "def app():\n    pass\n" > app.py
git add app.py
git commit -qm "Add app"

# Oops: build artifacts and a secrets file were committed by mistake.
echo "compiled bytecode" > app.pyc
mkdir -p build
echo "linker output" > build/app.o
echo "SECRET_KEY=hunter2" > .env
git add app.pyc build .env
git commit -qm "Add build output and env file (mistake!)"

# And there is fresh untracked junk lying around too.
echo "debug line" > debug.log
