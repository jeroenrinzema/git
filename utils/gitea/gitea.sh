#!/bin/bash
# Helpers to run a local Gitea server for the pull-request kata.
#
#   gitea-up     Start Gitea, create a training user, and seed a `team-app` repo.
#   gitea-down   Stop Gitea. Pass --purge to also delete all of its data.
#
# Training credentials (do NOT use for anything real):
#   user: kata   password: kata12345   web UI: http://localhost:3300
GITEA_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GITEA_USER="kata"
GITEA_PASS="kata12345"
GITEA_URL="http://localhost:3300"

gitea-up() {
    ( cd "$GITEA_DIR" && docker compose up -d ) || return 1

    printf "Waiting for Gitea to be ready"
    for _ in $(seq 1 60); do
        if curl -fsS "$GITEA_URL/api/healthz" >/dev/null 2>&1; then
            printf " ready!\n"
            break
        fi
        printf "."
        sleep 1
    done

    # Create the training user (ignore error if it already exists).
    ( cd "$GITEA_DIR" && docker compose exec -u git -T gitea \
        gitea admin user create --username "$GITEA_USER" --password "$GITEA_PASS" \
        --email "$GITEA_USER@example.com" --must-change-password=false ) \
        >/dev/null 2>&1

    # Start from a clean slate: drop any existing repo so re-running gives a
    # pristine exercise every time.
    curl -fsS -u "$GITEA_USER:$GITEA_PASS" -X DELETE \
        "$GITEA_URL/api/v1/repos/$GITEA_USER/team-app" >/dev/null 2>&1

    # Create a seeded repository (auto_init gives it a first commit).
    curl -fsS -u "$GITEA_USER:$GITEA_PASS" -X POST \
        "$GITEA_URL/api/v1/user/repos" \
        -H "Content-Type: application/json" \
        -d '{"name":"team-app","private":false,"auto_init":true,"default_branch":"main"}' \
        >/dev/null 2>&1

    echo ""
    echo "Gitea is up at $GITEA_URL"
    echo "  user: $GITEA_USER   password: $GITEA_PASS"
    echo "  repo: $GITEA_URL/$GITEA_USER/team-app"
    echo "  clone URL (with credentials baked in for training):"
    echo "    http://$GITEA_USER:$GITEA_PASS@localhost:3300/$GITEA_USER/team-app.git"
}

gitea-down() {
    if [ "$1" = "--purge" ]; then
        ( cd "$GITEA_DIR" && docker compose down -v )
        echo "Gitea stopped and all data purged."
    else
        ( cd "$GITEA_DIR" && docker compose down )
        echo "Gitea stopped (data kept; use 'gitea-down --purge' to wipe it)."
    fi
}
