# Git Kata: Rebasing a Branch

When your feature branch and `master` have both moved on, you have two ways to
combine them. **Merge** ties the two lines together with a merge commit, keeping
the exact shape of what happened. **Rebase** instead *replays* your branch's
commits on top of the latest `master`, as if you'd started your work from there
all along — giving a clean, straight-line history with no merge commit.

Rebase does this by rewriting your commits (they get **new hashes**), so the
golden rule is: rebase your own local, un-pushed work freely, but don't rebase
commits others have already based work on.

## Setup

```sh
$ source setup.sh
```

You get a repo where `master` and an `uppercase` branch have **diverged**:

```
        greeting="hello"        add README.md
A ────────── B ───────────────────── D          master
             │
             └───────── C                        uppercase
              greeting="HELLO"
```

`uppercase` branched off at `B` and changed the greeting; meanwhile `master`
moved on to `D` by adding a README. They share no tip.

## The task

1. List the branches with `git branch`. Which one are you on?
2. Look at the history: `git log --oneline --graph --all`. Confirm the fork above.
3. Switch to the feature branch: `git switch uppercase`.
4. Compare its log to `master`'s. It has commit `C` but is *missing* `master`'s
   `D` (the README).
5. Replay your work on top of the latest `master`:

   ```sh
   git rebase master
   ```

   git takes commit `C`, sets it aside, fast-forwards to `D`, then re-applies `C`
   on top — as a **new commit** `C'`.
6. **Draw what happened.** Run `git log --oneline --graph --all` again. The fork
   is gone; history is now a straight line `A → B → D → C'`. Note that `C`'s hash
   changed — it's a rewritten commit.
7. Switch to `master`: `git switch master`.
8. Merge the feature in: `git merge uppercase`. Because `uppercase` is now
   directly ahead of `master`, this is a **fast-forward** — no merge commit,
   `master` just slides up to `C'`.
9. Look at the final `git log --oneline --graph --all`: one clean line, both
   branches pointing at the same commit.

> :bulb: Compare this with kata 05 (fast-forward merge) and kata 08 (merge
> conflict). Rebase-then-fast-forward is how teams that like a **linear history**
> integrate feature branches.

## Useful commands

```shell
git branch                        # List branches; * marks the current one
git switch <branch-name>          # Move to a branch
git rebase <base-branch>          # Replay current branch's commits on top of <base>
git rebase --abort                # Bail out if a rebase hits a conflict you don't want
git merge <branch-name>           # Merge (fast-forwards when possible)
git log --oneline --graph --all   # See the shape of all branches at once
```
