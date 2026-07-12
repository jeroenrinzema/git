#!/bin/bash

# Include utils
source ../utils/utils.sh
kata="blame-and-pickaxe"

make-exercise-repo

# Build up a file over several commits with different authors, including a line
# that is introduced and later removed — perfect for blame and the "pickaxe".

export GIT_AUTHOR_NAME="Alice"; export GIT_AUTHOR_EMAIL="alice@example.com"
cat > server.py <<'EOF'
def start():
    port = 8080
    return port
EOF
git add server.py
git commit -qm "Add server with default port"

export GIT_AUTHOR_NAME="Bob"; export GIT_AUTHOR_EMAIL="bob@example.com"
cat > server.py <<'EOF'
def start():
    port = 8080
    debug = True
    return port
EOF
git commit -qam "Add debug flag"

export GIT_AUTHOR_NAME="Carol"; export GIT_AUTHOR_EMAIL="carol@example.com"
cat > server.py <<'EOF'
def start():
    port = 9090
    debug = True
    return port
EOF
git commit -qam "Change default port to 9090"

export GIT_AUTHOR_NAME="Alice"; export GIT_AUTHOR_EMAIL="alice@example.com"
cat > server.py <<'EOF'
def start():
    port = 9090
    return port
EOF
git commit -qam "Remove debug flag before release"

unset GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL
