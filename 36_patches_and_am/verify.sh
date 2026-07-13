#! /usr/bin/env sh

# The exercise is complete once the contributor's commits have landed in the
# maintainer's repo via `git am` — with the contributor's authorship preserved.

if [ ! -d upstream ]; then
  echo "No upstream/ repo found — run setup.sh first."
  exit 1
fi

has_mul=$(grep -c "def mul" upstream/calc.py 2>/dev/null)
applied=$(git -C upstream log --pretty="%s" | grep -c "Add mul()")

if [ "$has_mul" -ge 1 ] && [ "$applied" -ge 1 ]; then
  echo "The maintainer's repo has your contribution — patches applied with git am 🎉"
  echo "Author of the landed commit:"
  git -C upstream log --pretty="  %an <%ae>: %s" --grep="Add mul()" | head -1
else
  echo "Not there yet — upstream/calc.py should contain mul() applied via 'git am'."
  echo "Did you format-patch in exercise/ and 'git am' the files from upstream/?"
fi
