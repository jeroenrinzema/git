# Git Kata: Aborting Operations Cleanly

Merges, rebases and cherry-picks can stop halfway with a conflict. When that
happens it's easy to feel trapped — but every one of these operations has an
**undo button** that puts you back exactly where you started. Knowing the abort
commands turns "I've broken everything" into a non-event.

## Setup

```sh
$ source setup.sh
```

> NOTE: If running setup.sh on windows, run `./setup.sh` instead of sourcing it.

You get an `exercise` repo on `master`. There's also an `experiment` branch that
changed the **same line** as `master`, so any attempt to combine them conflicts.

## The task

### Abort a merge

1. On `master`, run `git merge experiment`. It stops with a conflict in
   `settings.txt`.
2. Run `git status` — you're now "in the middle of a merge" with unmerged paths.
3. Decide you don't want to deal with it right now: `git merge --abort`.
4. Run `git status` and `git log --oneline`. You're back on a clean `master`,
   exactly as before the merge. Nothing was committed.

### Abort a rebase

5. Try the other direction: `git rebase experiment`. It stops with the same
   conflict while replaying your commit.
6. Run `git status` — git tells you you're mid-rebase and even suggests
   `git rebase --abort`.
7. Bail out: `git rebase --abort`. Confirm with `git status` and
   `git log --oneline --graph` that `master` is untouched.

### Abort a cherry-pick

8. Try to cherry-pick the experiment commit onto master. First find its hash with
   `git log --oneline experiment`, then `git cherry-pick <hash>`. Conflict again.
9. Run `git status` — you're mid-cherry-pick.
10. Abort it: `git cherry-pick --abort`. Verify `master` is back to normal.

### The general pattern

11. Notice the shape: **`git <operation> --abort`** works for `merge`, `rebase`,
    `cherry-pick`, and `revert`. Whenever `git status` says you're in the middle
    of something, that's your escape hatch.

As a bonus: start a merge, and instead of aborting, actually resolve it this time
(edit `settings.txt`, `git add`, `git commit`) — so you can feel the difference
between backing out and finishing. Then you always have both options.

## Useful commands

```shell
git merge --abort         # Undo an in-progress conflicted merge
git rebase --abort        # Undo an in-progress conflicted rebase
git cherry-pick --abort   # Undo an in-progress conflicted cherry-pick
git revert --abort        # Undo an in-progress conflicted revert
git status                # Always tells you which operation you're in the middle of
```
