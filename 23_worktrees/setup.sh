#!/bin/bash

# Include utils
source ../utils/utils.sh
kata="worktrees"

make-exercise-repo

# Build up some history on master so there is something to work with
echo "# Awesome App" > README.md
git add README.md
git commit -m "Add project readme"

cat > app.py <<'EOF'
def greet(name):
    return "Hello, " + name


if __name__ == "__main__":
    print(greet("world"))
EOF
git add app.py
git commit -m "Add greeting app"

# An existing feature branch that a parallel agent could pick up
git branch feature/uppercase-greeting

# A stray, uncommitted change in your working tree: you are "in the middle
# of something" when an urgent hotfix request arrives.
echo "TODO: add tests" >> README.md
