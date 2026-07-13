#!/bin/bash

#Include utils
source ../utils/utils.sh

kata="merge-conflict"
make-exercise-repo

touch greeting.txt
git add greeting.txt
git commit -m "Add file greeting.txt"
echo "hello" > greeting.txt
git add greeting.txt
git commit -m "Add content to greeting.txt"

# Create a file on the feature branch
git checkout -b merge-conflict-branch
echo "This is a relevant fact conflicting with the truth" > file.txt
git add file.txt
git commit -m "add relevant fact"


git checkout master
echo "This is an indispensable truth!" > file.txt
git add file.txt
git commit -m "add indispensable truth!"
