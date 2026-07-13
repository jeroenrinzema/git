# Git Kata: Detached HEAD

`HEAD` is git's word for "where you are right now." Normally `HEAD` points at a
**branch** (like `master`), and that branch points at a commit — so when you
commit, the branch moves forward with you.

A **detached HEAD** is when `HEAD` points *directly at a commit* instead of a
branch. This happens whenever you check out a commit hash, a tag, or something
like `HEAD~3`. Git warns you loudly, which makes it feel scary — but it's just
git saying "any commits you make here won't belong to a branch, so they'll be
hard to find later." That's the only real risk: work created on a detached HEAD
can be garbage-collected if you wander off without saving it to a branch.

It's also genuinely useful: it's how you check out an old commit to poke around,
and — as you'll see — a perfectly good way to start a new branch from a past
point.

## Setup

```sh
$ source setup.sh
```

The setup builds four commits `A → B → C → D` and then deliberately leaves you in
a **detached HEAD**, checked out on commit `A`. So you start the kata already in
the "scary" state.

## The task

1. Run `git status` and `git log --oneline --graph --all`. Read the first line of
   `git status` carefully — it literally says `HEAD detached at <hash>`. In the
   graph, notice `HEAD` sitting on `A` while `master` is up on `D`.
2. **Restore normalcy**: reattach `HEAD` to a branch by switching to `master`
   (`git switch master`). Run `git status` again — HEAD is attached once more.

   Now the real exercise. We want a new branch called `the-beginning` rooted at
   the **first commit** (the one with message `A`) — and we'll do it *through* a
   detached HEAD on purpose, to show the state is a tool, not a trap.

3. Find the hash of commit `A` (`git log --oneline`), then check it out directly
   to detach HEAD there:

   ```sh
   git switch --detach <hash-of-A>     # or: git checkout <hash-of-A>
   ```

   Confirm with `git status` that you're detached at `A`.
4. Now anchor a branch to this spot so the position is no longer "loose":

   ```sh
   git switch -c the-beginning         # creates the branch here AND attaches HEAD
   ```

5. Verify with `git log --oneline --graph --all`: `the-beginning` now points at
   `A`, `master` still points at `D`, and `HEAD` is attached to `the-beginning`.

> :bulb: Takeaway: a detached HEAD is just "HEAD not on a branch." The fix is
> always the same — either `git switch <branch>` to go back to a branch, or
> `git switch -c <newbranch>` to turn your current spot *into* a branch and keep
> whatever you did there.

## Useful commands

```shell
git status                          # Tells you plainly if HEAD is detached
git log --oneline --graph --all     # See HEAD, branches, and commits at a glance
git switch --detach <ref>           # Intentionally detach HEAD onto a commit/tag
git checkout <ref>                  # Older equivalent that also detaches on a hash
git switch <branch>                 # Reattach HEAD to an existing branch
git switch -c <new-branch>          # Create a branch here and attach HEAD to it
```
