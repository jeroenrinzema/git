# Git Kata: Merge Conflict

Most merges just work — git combines changes from two branches automatically.
A **conflict** happens only when both branches changed *the same lines* (or, as
here, both added a file at the same path with different contents) and git can't
know which version you meant. It doesn't guess; it stops and asks **you** to
decide.

A conflict is not an error or a broken repo — it's a normal, expected pause.
Learning to read the conflict markers and finish the merge calmly is a core git
skill.

## Setup

```sh
$ source setup.sh
```

You get a `master` branch and a `merge-conflict-branch`. Both added a `file.txt`
with different content, so merging them will collide.

## The task

Both branches' changes need to end up on `master` when you're done.

1. Make sure you're on `master`, then merge the feature branch:

   ```sh
   git merge merge-conflict-branch
   ```

   git reports `CONFLICT (add/add): Merge conflict in file.txt` and stops.
2. Run `git status`. Note it says you're mid-merge and lists `file.txt` under
   **"Unmerged paths"**.
3. Open `file.txt` in your editor. You'll see git's conflict markers:

   ```
   <<<<<<< HEAD
   This is an indispensable truth!
   =======
   This is a relevant fact conflicting with the truth
   >>>>>>> merge-conflict-branch
   ```

   - Between `<<<<<<< HEAD` and `=======` is **your** side (`master`).
   - Between `=======` and `>>>>>>>` is the **incoming** side (the feature branch).

   Resolve it by editing the file into the final content you want and **deleting
   all three marker lines**. To keep both pieces, just remove the markers and
   leave both lines.
4. Follow what `git status` tells you: stage the resolved file and complete the
   merge:

   ```sh
   git add file.txt
   git commit          # accept the default "Merge branch ..." message
   ```

5. Run `git log --oneline --graph`. See the **merge commit** with two parents,
   tying both lines of history together.

> :bulb: Stuck or want out? `git merge --abort` returns you to exactly where you
> were before the merge — see kata 31 (Aborting operations). And kata 26 shows the
> same conflict, but arriving from a teammate over a remote.

## Useful commands

```shell
git merge <branch>                # Start the merge (may stop with a conflict)
git status                        # Shows unmerged paths and what to do next
git add <file>                    # Mark a conflict as resolved
git commit                        # Finish the merge
git merge --abort                 # Cancel and go back to before the merge
git log --oneline --graph         # See the resulting merge commit
```
