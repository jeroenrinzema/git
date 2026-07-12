#!/bin/bash
# Optional helper for the collaboration katas.
#
# The katas work perfectly well with a plain file-based "remote" (a bare repo you
# clone over a path). But if you want to experience a *real* networked remote —
# cloning and pushing over the wire — this spins up git's built-in daemon.
#
# It is deliberately locked down for training use: it binds to localhost only, so
# nothing is exposed to your network, and it has no authentication. Do NOT use
# this to serve anything you care about.
#
# Usage (run in a SECOND terminal, from a kata folder that has a `remote/`):
#     source ../utils/serve-remote.sh
#     serve-remote                 # serves ./remote on git://127.0.0.1:9418
#     serve-remote ./remote 9420   # custom base path and port
#
# Then, in your exercise clone, point origin at the served URL, e.g.:
#     git remote set-url origin git://127.0.0.1:9418/remote
#
# Stop the server with Ctrl-C.
serve-remote() {
    local base="${1:-$PWD}"
    local port="${2:-9418}"

    # Resolve to an absolute path so --base-path behaves predictably.
    base="$(cd "$base" && pwd)"

    echo "Serving repositories under: $base"
    echo "Clone/push URL:            git://127.0.0.1:$port/<repo>"
    echo "Press Ctrl-C to stop."

    git daemon \
        --reuseaddr \
        --listen=127.0.0.1 \
        --port="$port" \
        --base-path="$base" \
        --export-all \
        --enable=receive-pack \
        --verbose
}
