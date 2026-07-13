#!/bin/bash
source ../utils/utils.sh
pre-setup

echo "print('hello')" > app.py
git add app.py
git commit -qm "Initial app"

# Oops: a secrets file gets committed.
cat > secret.env <<'SECRET'
API_KEY=sk_live_51H8xLeaked1234567890abcdef
DB_PASSWORD=hunter2
SECRET
git add secret.env
git commit -qm "Add service config"

# ...and work continues on top, burying the secret in history.
echo "print('feature')" >> app.py
git add app.py
git commit -qm "Add a feature"
echo "# App" > README.md
git add README.md
git commit -qm "Add readme"

post-setup
