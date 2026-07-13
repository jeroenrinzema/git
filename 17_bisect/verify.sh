#! /usr/bin/env sh

cd exercise || exit

# `git bisect` records the first bad commit under refs/bisect/bad and leaves you
# checked out on it. Note: `git bisect reset` deletes that ref, so run this
# BEFORE resetting.
if ! git rev-parse --verify --quiet refs/bisect/bad >/dev/null; then
  echo "No bisect result found (refs/bisect/bad is missing)."
  echo "Run the verify script while bisect is still active — before 'git bisect reset'."
  exit 1
fi

if [ "$(git log -1 --format='%s' refs/bisect/bad --)" = 'Refactor shipping cost calculation' ]; then
  echo "You managed to find the bad commit with bisect 🎉"
else
  echo "Not quite — that isn't the commit that broke the checkout total."
  echo "Did you stop on the commit git flagged as the first bad one?"
fi
