# Git Kata: Remotes & Tracking Branches

Working with others means sharing commits through a **remote** — a copy of the
repository that everyone can push to and pull from (on a host like GitHub, or, in
these katas, a local "bare" repository standing in for one).

This kata is the foundation for every other collaboration exercise: what a remote
is, how `fetch`, `pull` and `push` differ, and how your local branches *track*
their counterparts on the remote (`master` vs `origin/master`).

## Setup

```sh
$ source setup.sh
```

> NOTE: If running setup.sh on windows, you can run into problems by sourcing the
> setup script. Instead, run `./setup.sh`, and the folders would be created
> correctly.

The setup creates a `remote/` bare repository (your "server") and a fresh
`exercise/` clone of it. You start inside `exercise/`.

## The task

1. Run `git remote -v`. What remote(s) are configured, and where do they point?
2. Run `git branch -a`. Which branches are local, and which are
   remote-tracking (they'll be shown as `remotes/origin/...`)?
3. Run `git branch -vv`. Notice how your local `master` is *tracking*
   `origin/master`. What does the `[origin/master]` annotation tell you?
4. Check out the release branch the "teammate" already pushed:
   `git switch release`. Git creates a local `release` that tracks
   `origin/release` automatically. Confirm with `git branch -vv`.
5. Switch back with `git switch master`.

   Now let's see the difference between `fetch` and `pull`.

6. Make a commit locally: change the greeting in `app.py`, then
   `git commit -am "Make the greeting warmer"`.
7. Run `git status`. Notice it says you are *ahead of `origin/master` by 1
   commit* — your commit exists locally but not on the remote yet.
8. Publish it: `git push`. Run `git status` again — you should now be
   up to date with `origin/master`.
9. Run `git log --oneline --all` and find where `origin/master` now points.

   Let's simulate a teammate pushing while you work. Because we don't have a
   second person, we'll push a commit straight to the remote via a throwaway
   clone.

10. From the `exercise` directory, run:

    ```sh
    git clone ../remote ../teammate
    cd ../teammate
    echo "extra line" >> README.md
    git commit -am "Teammate: expand the readme"
    git push
    cd ../exercise
    ```

11. Back in `exercise`, run `git status`. Does git know about the teammate's
    commit yet? (It doesn't — your knowledge of the remote is only as fresh as
    your last fetch.)
12. Run `git fetch`. Now run `git status` and `git log --oneline --all`. Where
    is `origin/master`, and where is your local `master`? `fetch` updated your
    *view* of the remote but did **not** change your working files.
13. Bring the teammate's commit into your branch with `git pull`. What is
    `git pull` doing here that `fetch` alone did not? (Hint: fetch **+**
    integrate.)
14. Run `git log --oneline --graph --all` to confirm your `master` and
    `origin/master` are back in sync.

As a bonus exercise, delete your local view of the release branch with
`git branch -d -r origin/release`, then run `git fetch` and watch it come back —
remote-tracking branches are just a cache of what the remote last told you.

## Bonus: run it against a real server

Everything above used a **file-based** remote (a bare repo cloned over a path),
which is all you need. If you'd like to experience a *real* networked remote,
git ships with a small server. In a **second terminal**, from this kata folder:

```sh
$ source ../utils/serve-remote.sh
$ serve-remote            # serves ./remote on git://127.0.0.1:9418 (localhost only)
```

Then, back in your `exercise` clone, repoint `origin` and use it exactly as
before:

```sh
$ git remote set-url origin git://127.0.0.1:9418/remote
$ git fetch && git pull
```

Stop the server with Ctrl-C when you're done.

## Useful commands

```shell
git remote -v                 # Show configured remotes and their URLs
git branch -a                 # Show local AND remote-tracking branches
git branch -vv                # Show each local branch and the remote branch it tracks
git fetch                     # Update your view of the remote; does NOT touch your files
git pull                      # fetch + integrate the remote branch into your current one
git push                      # Publish your commits to the tracked remote branch
git push -u origin <branch>   # Push a new branch and set it to track origin/<branch>
```
