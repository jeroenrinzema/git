#! /usr/bin/env sh

cd exercise || { echo "No exercise/ — run setup.sh first."; exit 1; }

# The secret must be gone from the working tree AND from every object in history.
still_in_history=$(git rev-list --all --objects | grep -c "secret.env")
key_in_history=$(git rev-list --all --objects | awk '{print $1}' \
  | while read -r o; do git cat-file -p "$o" 2>/dev/null; done | grep -c "sk_live_51H8xLeaked")

if [ -f secret.env ]; then
  echo "secret.env is still in the working tree — it wasn't removed."
elif [ "$still_in_history" -ne 0 ] || [ "$key_in_history" -ne 0 ]; then
  echo "The secret is still reachable in history — history wasn't fully rewritten."
  echo "Run: git filter-repo --path secret.env --invert-paths --force"
else
  echo "Scrubbed! secret.env is gone from every commit in history 🎉"
  echo "(Remember: in real life you'd still rotate the leaked key.)"
fi
