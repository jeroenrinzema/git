#!/bin/bash

# Include utils
source ../utils/utils.sh

pre-setup # Make exercise repo, and setup necessary.

cat > app.py <<'EOF'
def main():
    print("app")
EOF
printf '# App\n\nA smal example app.\n' > README.md
git add app.py README.md
git commit -qm "Initial app"

# The "fat" commit: two completely unrelated changes bundled into one — a new
# feature (greet) AND an unrelated typo fix in the README ("smal" -> "small").
cat > app.py <<'EOF'
def main():
    print("app")


def greet(name):
    return f"Hello, {name}!"
EOF
printf '# App\n\nA small example app.\n' > README.md
git add app.py README.md
git commit -qm "Add greeting and fix README typo"

# A later commit, so the split happens in the MIDDLE of history and the rebase
# has to replay this one on top afterwards.
printf '# App\n\nA small example app.\n\n## Usage\n\nRun `python app.py`.\n' > README.md
git add README.md
git commit -qm "Document usage"

post-setup
