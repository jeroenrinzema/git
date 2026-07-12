# Git Kata: Forks & Keeping in Sync with Upstream

When you contribute to a project you don't have write access to (most open-source
work, and many cross-team setups), you **fork** it: you make your own server-side
copy, push your work there, and open pull requests back to the original. Your fork
does **not** update itself — when the original project moves on, you have to pull
its changes in yourself.

This kata sets up that exact topology with two remotes:

- `origin` — **your fork** (you can push here).
- `upstream` — **the original project** (you fetch from here; you can't push).

## Setup

```sh
$ source setup.sh
```

> NOTE: If running setup.sh on windows, run `./setup.sh` instead of sourcing it.

You get an `exercise/` clone of your fork. Meanwhile the upstream project has
already gained a new commit that your fork doesn't have yet.

## The task

1. Run `git remote -v`. You only have `origin` (your fork) so far. It knows
   nothing about upstream.
2. Add the upstream project as a second remote:
   `git remote add upstream ../upstream`. Run `git remote -v` again to confirm
   you now have both.
3. Fetch upstream's history: `git fetch upstream`. Nothing in your working files
   changes — you've only downloaded upstream's commits.
4. Compare the two: `git log --oneline --graph --all`. Notice
   `upstream/master` is **one commit ahead** of your `master` and `origin/master`
   (the `Upstream: add sub()` commit).
5. Bring upstream's changes into your local `master`:

   ```sh
   git switch master
   git merge upstream/master        # or: git rebase upstream/master
   ```

   Verify `lib.py` now contains `sub()`.
6. Update **your fork** with the synced history: `git push origin master`.
   Now `origin/master` and `upstream/master` match again.

   Now contribute something back, the way you would in real life.

7. Create a feature branch: `git switch -c feature/mul`, add a function to
   `lib.py`:

   ```python
   def mul(a, b):
       return a * b
   ```

   then `git commit -am "Add mul()"`.
8. Push the branch to **your fork**: `git push -u origin feature/mul`.
   (On GitHub you would now open a pull request from your fork's
   `feature/mul` branch into the upstream project's `master`.)
9. Simulate the project moving on again while your PR is open: run
   `git fetch upstream` — imagine a new upstream commit lands. Keep your feature
   branch current by rebasing it onto the latest upstream:
   `git rebase upstream/master`. This is the routine that keeps a long-lived fork
   contribution mergeable.

As a bonus, set upstream's `master` as the default for pulls on your local
`master` with `git branch --set-upstream-to=upstream/master master`, and think
about when you'd want your `master` to track your fork versus the original
project.

## Useful commands

```shell
git remote add upstream <url>   # Register the original project as a second remote
git remote -v                   # List all remotes and their URLs
git fetch upstream              # Download upstream's commits (no file changes)
git merge upstream/master       # Integrate upstream into your branch (merge)
git rebase upstream/master      # Integrate upstream by replaying your commits
git push origin master          # Update your fork with the synced history
```
