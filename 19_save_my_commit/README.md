# Git Kata: Save My Commit — Recovering with the Reflog

You did great work, committed it, and then a stray `git reset --hard` wiped it off
your branch. The commit isn't on `master` anymore, `git log` doesn't show it, and
the file is gone from your working directory. Panic?

No. Here's the reassuring truth: **git almost never deletes your commits
immediately.** When you reset, the old commit is still sitting in the object
database — it's just no longer *reachable* from any branch. And git keeps a
private log of every place `HEAD` has ever been: the **reflog**. That log is your
safety net and your undo history.

In this kata we lost `holygrail.txt` to a hard reset, and we'll recover it three
ways — then find out what it actually takes to lose a commit *for good*.

## Setup

```sh
$ source setup.sh
```

The setup makes an `initial-commit`, adds three commits (the last one adds
`holygrail.txt`), then does `git reset --hard HEAD~3` — throwing those three
commits off `master`.

## The task

1. Run `git log --oneline`. Confirm history is brief — only the initial commit.
2. Run `ls`. `holygrail.txt` is nowhere in sight.
3. Run `git reflog`. **This is the key move.** Every line is a past position of
   `HEAD`; find the entry `commit: found the holy grail` and note its hash (or its
   `HEAD@{n}` shorthand).

   ### Recovery 1 — reset the branch back onto the lost commit

4. Move `master` forward to that commit:

   ```sh
   git reset --hard <hash-of-holygrail-commit>
   ```

5. Run `git log --oneline` and `ls`. All three commits and `holygrail.txt` are
   back — history fully restored.
6. Undo your fix to try the next approach: `git reset --hard initial-commit`.

   ### Recovery 2 — cherry-pick just the one commit

7. Instead of restoring the whole branch, grab only the holy-grail commit:

   ```sh
   git cherry-pick <hash-of-holygrail-commit>
   ```

8. Compare with Recovery 1: `git log` now shows *initial + holygrail* (not the two
   middle commits), and `holygrail.txt` is back. Use reset when you want the whole
   lost tip; cherry-pick when you want one specific commit.
9. Undo again: `git reset --hard initial-commit`.

   ### What actually destroys a commit?

10. A common myth is that `git gc` (garbage collection) will wipe your lost work.
    Test it — run `git gc`, then `git reflog`. The holy-grail commit is **still
    listed**, and Recovery 1 or 2 still works. Plain `gc` won't touch objects your
    reflog still references. Your safety net holds.
11. So how *is* a commit truly lost? The reflog has to forget it first, and then a
    pruning `gc` has to collect it. You can force that "point of no return":

    ```sh
    git reflog expire --expire=now --all
    git gc --prune=now
    ```

12. Now `git reflog` no longer lists it, and `git fsck --no-reflogs` reports no
    dangling commit — recovery is finally impossible. In real life this only
    happens naturally after the reflog's expiry window (90 days by default for
    reachable entries, 30 for unreachable). **Takeaway:** you have a long grace
    period, and the reflog is the first place to look whenever something
    "disappears".

## Relevant git commands

```shell
git reflog                        # Every past position of HEAD — your undo history
git reset --hard <ref>            # Move the current branch (and working tree) to <ref>
git cherry-pick <ref>            # Re-apply one specific commit onto your branch
git log --oneline                # Check what history looks like now
git fsck --no-reflogs            # Find dangling (unreferenced) objects
```
