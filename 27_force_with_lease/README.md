# Git Kata: Safe Force-Pushing with `--force-with-lease`

Sometimes you need to **rewrite** history that you've already pushed — squashing
messy work-in-progress commits before review, or fixing a commit message. Because
the rewrite changes commit hashes, a normal `git push` is rejected, and you have
to force it.

But a blunt `git push --force` will happily **overwrite a teammate's commits** if
they pushed to the same branch while you were rewriting. `--force-with-lease` is
the safe version: it force-pushes **only if** the remote branch is still where you
last saw it. This kata shows both the rewrite and why the "lease" matters.

## Setup

```sh
$ source setup.sh
```

> NOTE: If running setup.sh on windows, run `./setup.sh` instead of sourcing it.

You get an `exercise/` clone on a `feature/widget` branch with three messy commits
(`wip`, `fix`, `actually works now`) already pushed to the remote.

## The task

1. Run `git log --oneline`. See the three untidy commits you pushed.
2. Squash them into one clean commit. Start an interactive rebase over the last
   three: `git rebase -i HEAD~3`. Mark the first as `pick` and the other two as
   `squash` (or `fixup`), then give it a tidy message like
   `Add widget()`. (See kata 12 if interactive rebase is new to you.)
3. Run `git log --oneline` — three commits are now one, with a **new hash**.
4. Try a normal `git push`. It is **rejected**: your local branch is no longer a
   fast-forward of `origin/feature/widget`, because you rewrote it.
5. Push the rewrite safely with `git push --force-with-lease`. It succeeds,
   because the remote branch is exactly where you last saw it — nobody else
   pushed in the meantime.
6. Confirm with `git log --oneline` that the remote and local now match the tidy
   history.

   Now let's see the safety net actually catch something. We'll simulate a
   teammate pushing to your feature branch after your last fetch.

7. From the `exercise` directory, run:

   ```sh
   git clone ../remote ../teammate
   cd ../teammate
   git switch feature/widget
   echo "# reviewed by teammate" >> widget.py
   git commit -am "Teammate: add a note"
   git push
   cd ../exercise
   ```

8. Back in `exercise`, make another rewrite: `git commit --amend -m "Add
   widget() with docs"` (this changes your last commit's hash).
9. Try `git push --force-with-lease`. It is **rejected!** git noticed
   `origin/feature/widget` moved since your last fetch, and refused to clobber
   the teammate's commit. This is exactly the disaster a plain `--force` would
   have caused.
10. Do the right thing: `git fetch`, inspect what changed with
    `git log --oneline --graph --all`, integrate the teammate's commit
    (e.g. `git rebase origin/feature/widget`), and only then
    `git push --force-with-lease` again.

The lesson: **prefer `--force-with-lease` over `--force`** on any shared branch.
It force-pushes when it's safe and stops you when it isn't.

## Useful commands

```shell
git rebase -i HEAD~3          # Interactively squash/reword recent commits
git commit --amend            # Rewrite the most recent commit
git push --force-with-lease   # Force-push only if the remote hasn't moved
git push --force              # Force-push unconditionally (dangerous on shared branches)
git fetch                     # Update your view before re-attempting a lease push
```
