#!/bin/bash
source ../utils/utils.sh

pre-setup # Make exercise repo, and setup necessary.

# A tiny "app": price.sh prints the checkout total, which must always be 42.
# test.sh is the build/CI check that guards that invariant.
cat > price.sh <<'EOF'
#!/usr/bin/env bash
# Print the checkout total for the cart.
subtotal=40
shipping=2
echo $(( subtotal + shipping ))
EOF
chmod +x price.sh

cat > test.sh <<'EOF'
#!/usr/bin/env bash
# CI check: the checkout total must always be 42.
total=$(./price.sh)
if [ "$total" = "42" ]; then
  echo "test passed"
  exit 0
else
  echo "test failed (got $total, expected 42)"
  exit 1
fi
EOF
chmod +x test.sh

git add price.sh test.sh
git commit -m "Add checkout with passing CI check"
git tag initial-commit

# Build up an innocent-looking history. Somewhere in the middle, one commit
# quietly breaks the checkout total — that's the commit bisect must find.
for i in $(seq 1 30)
do
  if [ "$i" -eq 22 ]; then
    # The bug: a well-meaning "refactor" bumps shipping and breaks the total.
    cat > price.sh <<'EOF'
#!/usr/bin/env bash
# Print the checkout total for the cart.
subtotal=40
shipping=5
echo $(( subtotal + shipping ))
EOF
    git commit -aqm "Refactor shipping cost calculation"
  else
    echo "item $i" >> catalog.txt
    git add catalog.txt
    git commit -qm "Add catalog item $i"
  fi
done

post-setup
