# Git Kata: Splitting a Commit

Interactive rebase can *combine* commits (squash/fixup) — but it can also do the
opposite: take one commit that did too much and **split it into several**. This is
a common review request: "great change, but please separate the feature from the
unrelated typo fix so each is reviewable on its own."

The trick is the `edit` action in `git rebase -i`. It pauses the rebase *at* a
commit with that commit already applied. From there you **un-commit** it while
keeping its changes in your working tree (`git reset HEAD^`), then re-commit the
pieces one at a time.

## Setup

```sh
$ source setup.sh
```

You get a repo whose middle commit is a "fat" one — **"Add greeting and fix README
typo"** — that bundles two unrelated changes: a new `greet()` function in `app.py`
*and* a typo fix in `README.md`. There's a later commit ("Document usage") on top,
so you'll also see the rebase replay work that sits above the split.

## The task

Split that one fat commit into two clean commits: **"Add greeting"** (only
`app.py`) and **"Fix README typo"** (only `README.md`).

1. Look at the history and the offending commit:

   ```sh
   git log --oneline
   git show HEAD~1        # note it touches BOTH app.py and README.md
   ```

2. Start an interactive rebase that includes the fat commit:

   ```sh
   git rebase -i HEAD~2
   ```

   In the editor, change the action for **"Add greeting and fix README typo"**
   from `pick` to `edit` (leave "Document usage" as `pick`). Save and close.
3. The rebase stops **at** that commit, with its changes already committed. Undo
   just that commit, keeping its changes in your working tree:

   ```sh
   git reset HEAD^
   ```

   (This is a *mixed* reset: the commit is gone, but `app.py` and `README.md`
   still hold the changes — now unstaged. Run `git status` to see both.)
4. Commit the **first** logical piece on its own:

   ```sh
   git add app.py
   git commit -m "Add greeting"
   ```

5. Commit the **second** piece:

   ```sh
   git add README.md
   git commit -m "Fix README typo"
   ```

6. Finish the rebase so "Document usage" is replayed on top:

   ```sh
   git rebase --continue
   ```

7. Check your work with `git log --oneline`. The single fat commit is now two
   focused commits, with the later commit cleanly on top. Confirm with
   `git show` that "Add greeting" touches only `app.py` and "Fix README typo"
   touches only `README.md`.

> :bulb: **Splitting *within a single file*.** If the two changes lived in the
> same file, you couldn't separate them with `git add <file>`. That's what
> **`git add -p`** (patch mode) is for: git offers each hunk in turn and you press
> `y`/`n` to stage only some of them. Try building this habit — it's the key to a
> clean, reviewable history. (See also kata 12, interactive rebase, for the
> combine direction.)

## Verify

```bash
$ cd ..
$ ./verify.sh
```

## Useful commands

```shell
git rebase -i <base>          # Open the rebase "recipe"; use `edit` to pause on a commit
git reset HEAD^               # Un-commit the current commit, keep its changes (mixed reset)
git add <file>               # Stage one file's worth of the change
git add -p                   # Stage individual hunks — split changes inside one file
git commit -m "..."          # Commit each logical piece separately
git rebase --continue         # Resume the rebase after editing
git rebase --abort            # Bail out and return to where you started
```
