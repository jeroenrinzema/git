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
   **not cloned**. So the hook you just wrote protects *only you* — a teammate who
   clones the repo gets none of it. The fix is to commit the hook as a normal
   tracked file and point git at it with **`core.hooksPath`**. Walk through the
   worked example below, then come back for the bonus.

#### Worked example: share the `DO NOT COMMIT` guard with the team

Move the hook into a tracked `hooks/` folder and commit it (run these from the
`exercise` directory):

```sh
mkdir hooks
cat > hooks/pre-commit <<'EOF'
#!/bin/sh
if git diff --cached | grep -q "DO NOT COMMIT"; then
    echo "pre-commit: found a 'DO NOT COMMIT' marker — aborting."
    exit 1
fi
EOF
chmod +x hooks/pre-commit
git add hooks/pre-commit
git commit -m "Add shared pre-commit hook"
```

Now tell git to use that directory instead of `.git/hooks/`:

```sh
git config core.hooksPath hooks
```

Trip it again (add `x = 1  # DO NOT COMMIT` to `app.py` and try to commit) and
confirm it still fires — but this time the hook is **versioned and pushed**, so it
travels with the repo.

**The catch:** `core.hooksPath` is *local config*, and config is **not** cloned.
A teammate who clones gets the `hooks/` files, but git won't run them until they
each run `git config core.hooksPath hooks` once. Relying on everyone remembering
that is exactly where hand-rolled setups fall down.

#### The real-world answer: a hook manager

In practice nobody wires hooks up by hand — you use a **hook manager** that
installs them automatically as part of a step developers already run. The clever
trick these tools share: they hang the "set `core.hooksPath`" step off your
package manager's install lifecycle, so hooks appear the first time someone
installs dependencies. No extra command to forget.

**For frontend / JavaScript projects, the de-facto standard is
[Husky](https://typicode.github.io/husky/).** You add it once:

```sh
npm install --save-dev husky
npx husky init          # creates .husky/, and adds a "prepare": "husky" script
```

Because npm runs the `prepare` script automatically on every `npm install`, each
teammate gets the hooks wired up the moment they install the project's
dependencies — the manual `git config` step disappears. You commit your hooks
under `.husky/` (e.g. `.husky/pre-commit`), and they're live for everyone.

Husky is almost always paired with **[lint-staged](https://github.com/lint-staged/lint-staged)**,
which runs linters/formatters (ESLint, Prettier) on **only the staged files** —
so `.husky/pre-commit` is usually just:

```sh
npx lint-staged
```

For other stacks the same idea shows up under different names:

- **[pre-commit](https://pre-commit.com/)** — language-agnostic, hugely popular in
  Python; you commit a `.pre-commit-config.yaml` and run `pre-commit install` once.
- **[Lefthook](https://github.com/evilmartians/lefthook)** — a single fast binary,
  polyglot, config in `lefthook.yml`; great for monorepos.

The takeaway: understand the raw `core.hooksPath` mechanism (you just built it by
hand!), but in a real project reach for Husky (JS/FE) or Lefthook/pre-commit
(everything else) so the wiring is automatic.

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
