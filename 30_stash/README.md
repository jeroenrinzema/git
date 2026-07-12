# Git Kata: Stashing Work in Progress

You're halfway through a change when something urgent comes up — a teammate needs
a quick fix, or you must switch branches to review a colleague's work. Your
working tree is dirty and you're not ready to commit. `git stash` sets your
uncommitted changes aside, gives you a clean tree, and lets you restore them
later.

(For a different way to work on two things at once — a separate directory per
branch — see kata 23 _Worktrees_. Stash swaps changes in place; worktrees give
each branch its own checkout.)

## Setup

```sh
$ source setup.sh
```

> NOTE: If running setup.sh on windows, run `./setup.sh` instead of sourcing it.

You start on `master` with a work-in-progress edit to `app.py` and an untracked
`scratch.txt`. There's also a `hotfix` branch waiting.

## The task

1. Run `git status`. See your modified `app.py` and untracked `scratch.txt`.
2. Try to `git switch hotfix`. It works here, but imagine a case where git
   refuses because your changes would be overwritten. Switch back to `master`.
3. Stash your tracked changes: `git stash`. Run `git status` — your tree is clean
   and `app.py` is back to the committed version. (Note `scratch.txt` is still
   there: plain `git stash` leaves **untracked** files alone.)
4. List your stashes with `git stash list`. Note the `stash@{0}` reference.
5. Now that the tree is clean, switch to the urgent work:
   `git switch hotfix`. Make a fix — change the return value in `app.py` to `99`
   — and `git commit -am "Hotfix: bump return value"`.
6. Go back with `git switch master`.
7. Restore your work in progress: `git stash pop`. Confirm `app.py` shows your
   `work in progress` edit again, and that the stash is gone from
   `git stash list`.
8. Explore the difference between `pop` and `apply`: make a change, `git stash`,
   then `git stash apply`. Run `git stash list` — the stash is **still there**
   (`apply` restores but keeps it; `pop` restores and deletes). Drop it manually
   with `git stash drop`.
9. Stash **including** untracked files: `git stash -u`. Now `scratch.txt` is
   stashed too and your directory is completely clean. Restore it with
   `git stash pop`.

As a bonus, create two separate stashes, use `git stash list` to see both, and
restore a specific one with `git stash apply stash@{1}`. Also try
`git stash show -p stash@{0}` to preview a stash as a diff before applying it.

## Useful commands

```shell
git stash                 # Stash tracked, modified files; clean the working tree
git stash -u              # Also stash untracked files
git stash list            # List all stashes
git stash pop             # Restore the latest stash AND remove it from the list
git stash apply           # Restore the latest stash but KEEP it in the list
git stash show -p         # Show a stash as a diff
git stash drop            # Delete a stash without applying it
```
