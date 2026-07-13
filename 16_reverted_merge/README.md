# Git Kata: Reverting a Merge (and the Trap That Follows)

Reverting a normal commit is easy. Reverting a **merge** commit has a famous
sharp edge that surprises even experienced developers — and this kata walks you
straight into it, then back out.

The core lesson up front, so you know what you're looking for:

> Reverting a merge undoes the merge's **file changes**, but it does **not** undo
> the fact that the merge happened. History still records the two branches as
> joined. So if you later try to merge that branch again, git says "already
> merged" and your changes **do not come back** — even though the files clearly
> don't have them.

## The story

Your team depends on `library-1.2.3`, maintained by another team. You cautiously
integrate the new `library-1.2.4` on a branch `integrate-library-1.2.4`, then
merge it into `master`. After the merge you discover the new library has a bug, so
you **revert the merge** to keep it out of production while the other team fixes
it. Then you try to bring the (now fixed) library back in — and hit the trap.

## Setup

```sh
$ source setup.sh
```

This leaves you on `master` after the merge has already happened, with two files:

- `lib.txt` — the library (currently at `1.2.4`).
- `mymodule.txt` — your app, containing the library line plus **feature X** (added
  on master *before* the merge) and **feature Y** (added *after* the merge).

Run `git log --oneline --graph --all` to see the merge commit joining the two
lines.

## The task

### 1. Revert the merge

Find the merge commit's hash, then revert it. A merge has two parents, so you
must tell git which side to keep as the "mainline" with `-m 1` (parent 1 =
`master`):

```sh
git revert -m 1 <merge-sha>
```

This conflicts in `mymodule.txt`, because you need to decide what survives:

- **Keep** feature X and feature Y — they are *your* work, not the library's.
  (X was committed on `master` before the merge; Y after. Assume Y works fine with
  the old library too.)
- **Undo** the library-`1.2.4` lines — that's the whole point of the revert.

Resolve `mymodule.txt` to contain the old-library module line plus X and Y, then:

```sh
git add mymodule.txt lib.txt
git revert --continue
```

Confirm `lib.txt` is back to `1.2.3` and `mymodule.txt` kept X and Y.

### 2. The library team ships a fix

Switch to the integrate branch and play the other team, fixing the bug in the
library:

```sh
git switch integrate-library-1.2.4
# edit lib.txt — e.g. add a "bug fixed" line
git commit -am "Fix library bug"
```

### 3. Try to merge the fix back — and watch it fail

```sh
git switch master
git merge integrate-library-1.2.4
```

`lib.txt` updates as you'd expect — but look at `mymodule.txt`: the library-1.2.4
changes **do not return**. This is the trap. Because the original merge still
exists in history, git treats it as the last shared point and thinks the module
changes are already present. (Deep dive:
[Reverting a faulty merge](https://github.com/git/git/blob/master/Documentation/howto/revert-a-faulty-merge.txt).)

### 4. Back out of the broken merge

```sh
git reset --hard <sha-of-the-commit-before-this-merge>
```

### 5. Revert the revert, then merge cleanly

The fix is to first **undo your earlier revert** — bringing the module's library
changes back onto `master` — and only *then* merge:

```sh
git revert <sha-of-your-revert-commit>   # "revert the revert"
git merge integrate-library-1.2.4        # now it works
```

Check `mymodule.txt`: the library changes are back **and** you've got the bug fix.
The trap is sprung and escaped.

> :bulb: Real-world takeaway: if you revert a merge but intend to bring that branch
> in again later, remember you'll need to *revert the revert* first. Many teams
> avoid the whole issue by fixing forward on a fresh branch instead of re-merging a
> reverted one.

## Useful commands

```shell
git log --oneline --graph --all    # See the merge commit and both branches
git revert -m 1 <merge-sha>        # Revert a merge, keeping parent 1 as mainline
git add <file> && git revert --continue   # Finish a conflicted revert
git switch <branch>                # Change branches to play each team
git merge <branch>                 # Attempt the (re-)merge
git reset --hard <sha>             # Back out of the broken merge
git revert <sha>                   # Revert the revert to restore the changes
```
