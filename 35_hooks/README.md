# Git Kata: Hooks — Automating Team Quality Gates

Git can run your own scripts at key moments — before a commit, before a push, and
so on. These **hooks** let a team enforce shared standards automatically: reject a
commit that leaves in a debug marker, run the formatter, block a direct commit to
`main`. This kata builds a `pre-commit` hook by hand so you understand what tools
like _pre-commit_ and _husky_ do under the covers.

## Setup

```sh
$ source setup.sh
```

> NOTE: If running setup.sh on windows, run `./setup.sh` instead of sourcing it.

You get a small `exercise` repo. Hooks live in `.git/hooks/` inside it.

## The task

1. Look in `.git/hooks/`. It's full of `*.sample` files — disabled examples git
   ships with. A hook runs only if there's an **executable** file with the exact
   hook name (no `.sample`).
2. Create `.git/hooks/pre-commit` with this content — it blocks any commit whose
   staged changes still contain the marker `DO NOT COMMIT`:

   ```sh
   #!/bin/sh
   if git diff --cached | grep -q "DO NOT COMMIT"; then
       echo "pre-commit: found a 'DO NOT COMMIT' marker — aborting."
       exit 1
   fi
   ```

3. Make it executable: `chmod +x .git/hooks/pre-commit`. (A non-executable hook is
   silently ignored — a classic gotcha.)
4. Try to commit something clean: add a line to `app.py` and
   `git commit -am "Tidy app"`. It succeeds — the hook ran and found nothing.
5. Now trip the hook: add a line `x = 1  # DO NOT COMMIT` to `app.py`,
   `git add app.py`, and `git commit -m "Add debug line"`. The commit is
   **rejected** and your message is not recorded.
6. Confirm with `git log --oneline` that the bad commit never happened. Remove the
   marker line, then commit again — it goes through.
7. See the escape hatch every hook has: `git commit --no-verify` (or `-n`) skips
   pre-commit hooks entirely. Useful in emergencies, but it means hooks are a
   **convenience, not a security control** — anyone can bypass a local hook.

### Why this matters for a team — and its catch

8. Hooks live in `.git/hooks/`, which is **not** part of the repository and is
   **not cloned**. So a hook you create doesn't automatically reach your
   teammates. Note how the two standard ways teams solve that work:
   - **`core.hooksPath`** — commit a `hooks/` directory in the repo and point git
     at it: `git config core.hooksPath hooks`. Try it: move your hook to a
     tracked `hooks/` folder, set the config, and confirm it still fires.
   - A hook manager (e.g. the _pre-commit_ framework) that installs shared hooks
     from a committed config file — the same idea, with more batteries included.

As a bonus, write a `pre-push` hook (`.git/hooks/pre-push`) that refuses to push
if any commit message contains the word `WIP`.

## Useful commands

```shell
ls .git/hooks                 # See available hooks (and the .sample templates)
chmod +x .git/hooks/pre-commit  # A hook must be executable to run
git commit --no-verify        # Bypass pre-commit/commit-msg hooks (emergencies only)
git config core.hooksPath hooks # Use a tracked, shareable hooks directory
git diff --cached             # What a pre-commit hook typically inspects
```
