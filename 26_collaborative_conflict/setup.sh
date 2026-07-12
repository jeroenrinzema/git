#!/bin/bash

# Include utils
source ../utils/utils.sh
kata="collaborative-conflict"

rm -rf seed

# Shared remote with a config file everyone edits.
make-bare-remote-repo
git clone -q ./remote seed
cd seed
cat > config.yml <<'EOF'
app: recipes
port: 8080
timeout: 30
EOF
git add config.yml
git commit -qm "Add app config"
git push -q origin master
cd ..
rm -rf seed

# Your clone.
clone-remote-to-exercise

# A teammate changes the SAME line you are about to change, and pushes it.
cd ..
git clone -q ./remote seed
cd seed
sed -i.bak 's/port: 8080/port: 9090/' config.yml && rm -f config.yml.bak
git commit -qam "Teammate: move app to port 9090"
git push -q origin master
cd ..
rm -rf seed
cd exercise
