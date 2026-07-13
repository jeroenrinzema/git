#! /usr/bin/env sh

cd exercise || { echo "No exercise/ — run setup.sh first."; exit 1; }

# The fat commit should be gone, replaced by two focused commits — one touching
# only app.py, the other only README.md.
fat=$(git log --pretty="%s" | grep -c "Add greeting and fix README typo")
greeting=$(git log --pretty="%H %s" | grep "Add greeting$" | head -1 | cut -d' ' -f1)
typo=$(git log --pretty="%H %s" | grep "Fix README typo" | head -1 | cut -d' ' -f1)

ok=1
[ "$fat" -eq 0 ] || { echo "The combined 'Add greeting and fix README typo' commit is still there."; ok=0; }
[ -n "$greeting" ] || { echo "No separate 'Add greeting' commit found."; ok=0; }
[ -n "$typo" ] || { echo "No separate 'Fix README typo' commit found."; ok=0; }

if [ -n "$greeting" ]; then
  files=$(git show --name-only --pretty="" "$greeting")
  echo "$files" | grep -q "app.py" && ! echo "$files" | grep -q "README.md" || {
    echo "'Add greeting' should change only app.py."; ok=0; }
fi
if [ -n "$typo" ]; then
  files=$(git show --name-only --pretty="" "$typo")
  echo "$files" | grep -q "README.md" && ! echo "$files" | grep -q "app.py" || {
    echo "'Fix README typo' should change only README.md."; ok=0; }
fi

if [ "$ok" -eq 1 ]; then
  echo "Nicely split — one commit became two focused, reviewable commits 🎉"
else
  echo "Not there yet — split the fat commit with 'git rebase -i' + 'git reset HEAD^'."
fi
