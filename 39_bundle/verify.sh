#! /usr/bin/env sh

# Success = the laptop clone, created from a bundle file, has received the
# incremental work (Day 3 / Day 4) — all without a network remote.

if [ ! -d laptop ]; then
  echo "No laptop/ clone yet — clone from project.bundle first."
  exit 1
fi

if git -C laptop log --oneline | grep -q "Day 4"; then
  echo "The laptop received the incremental bundle — history moved by file alone 🎉"
else
  echo "Not there yet — the laptop is missing the later commits."
  echo "Create update.bundle (shared..master) in project and 'git pull' it into laptop."
fi
