#!/bin/bash

# Include utils
source ../utils/utils.sh
kata="remotes-and-tracking"

# A leftover seed clone from a previous run would break a re-run; clean it up.
rm -rf seed

# Create the shared "remote" — a bare repo standing in for a host like github.com.
make-bare-remote-repo

# Seed the remote with some starting history via a throwaway clone.
git clone -q ./remote seed
cd seed

echo "# Team App" > README.md
git add README.md
git commit -qm "Add project readme"

cat > app.py <<'EOF'
def main():
    print("hello team")


if __name__ == "__main__":
    main()
EOF
git add app.py
git commit -qm "Add app entry point"
git push -q origin master

# A second branch that already lives on the remote, as if a teammate pushed it.
git switch -qc release
echo "Changelog" > CHANGELOG.md
git add CHANGELOG.md
git commit -qm "Start changelog on release branch"
git push -q origin release

cd ..
rm -rf seed

# Give the learner a fresh clone to work in (leaves you inside exercise/).
clone-remote-to-exercise
