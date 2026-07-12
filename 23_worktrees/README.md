# Git Kata: Worktrees

A worktree lets you check out **multiple branches at the same time**, each in its
own directory, while sharing a single `.git` database. Instead of `git stash`-ing
your work, switching branches, and switching back, you simply open a second
working directory that lives on a different branch.

This is handy whenever you need to touch another branch without disturbing what
you are doing right now:

- Handle an urgent hotfix while your feature work sits untouched — no stash, no
  checkout dance.
- Keep a dev server, editor, or debugger running in one worktree while you build
  or test in another.
- Review or test a colleague's branch by just `cd`-ing into a worktree, then
  throw it away when you're done.

> :bulb: This is especially useful when running AI coding agents: give each agent
> its own worktree on its own branch and several can work in parallel — no merge
> conflicts on the working tree, no fighting over `git switch`, and your main
> checkout keeps running undisturbed.

## Setup

```sh
$ source setup.sh
```

> NOTE: If running setup.sh on windows, you can run into problems by sourcing the
> setup script. Instead, run `./setup.sh`, and the folders would be created
> correctly.

## The task

After running the setup script you are inside the `exercise` repository. It has a
`master` branch with two commits, an existing `feature/uppercase-greeting` branch,
and an **uncommitted change** in `README.md` — you are in the middle of something.

An urgent hotfix request just arrived. Without worktrees you would have to stash
your change first. Let's use a worktree instead.

1. Run `git status`. Confirm you have an uncommitted change and are on `master`.
2. List your worktrees with `git worktree list`. How many are there right now?
3. Create a worktree for the hotfix on a brand-new branch:
   `git worktree add ../hotfix -b hotfix`.
   What did git print, and what happened on disk in the parent directory?
4. Run `git worktree list` again. What changed?
5. Run `git status` in your **current** directory. Is your uncommitted change to
   `README.md` still there? (This is the point: your work was never touched.)
6. `cd ../hotfix`. What branch are you on (`git branch --show-current`)? What
   files are present? Is your `README.md` change visible here?
7. Fix the "bug": change `"Hello, "` to `"Hi, "` in `app.py`, then
   `git commit -am "Hotfix: friendlier greeting"`.
8. `cd` back to the `exercise` directory. Notice your uncommitted change is still
   waiting exactly as you left it — you never had to stash.

   Now pick up a second, parallel line of work. The
   `feature/uppercase-greeting` branch already exists.

9. Attach a worktree to that **existing** branch:
   `git worktree add ../feature feature/uppercase-greeting`.
   (Note: no `-b` this time, because the branch already exists.)
10. Try to add a *second* worktree for the same branch:
    `git worktree add ../feature2 feature/uppercase-greeting`. What happens, and
    why does git refuse? (A branch can only be checked out in one worktree.)
11. `cd ../feature`. This is an isolated sandbox for the feature. Change the
    greeting to uppercase in `app.py` (`"HELLO"` style) and
    `git commit -am "Feature: shout the greeting"`.
12. From here run `git log --oneline --graph --all`. You should see three lines of
    work — `master`, `hotfix`, and `feature/uppercase-greeting` — that were all
    developed **simultaneously**, each in its own directory.
13. `cd` back to `exercise` and inspect `git worktree list` once more. Note that
    each worktree is pinned to a different branch and commit.

    Time to clean up, which is just as important as creating them.

14. Merge the hotfix into master: from `exercise` run `git merge hotfix`.
    (Commit your pending `README.md` change first, or stash it, if git complains.)
15. Remove the finished hotfix worktree: `git worktree remove ../hotfix`.
    What happens to the `hotfix` **branch** — is it gone too? (Removing a worktree
    does *not* delete the branch.)
16. Manually delete the `../feature` directory with `rm -rf ../feature`, then run
    `git worktree list`. It still lists a stale entry! Run `git worktree prune`
    and list again to clean up the bookkeeping.
17. As a bonus: try `git worktree add --detach ../review HEAD~1` to check out a
    past commit in a throwaway worktree — handy for inspecting or testing an old
    state without leaving your current branch.

As a bonus exercise, draw the repository as a single `.git` database with several
working directories hanging off it, each pinned to a different branch.

## Useful commands

```shell
git worktree add <path> -b <new-branch>   # New branch in a new worktree
git worktree add <path> <existing-branch> # Existing branch in a new worktree
git worktree add --detach <path> <commit> # Detached HEAD worktree for inspection
git worktree list                         # Show all worktrees and their branches
git worktree remove <path>                # Remove a worktree (keeps the branch)
git worktree prune                        # Clean up records of deleted worktrees
```
