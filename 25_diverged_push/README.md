# Git Kata: Diverged History & Rejected Push

The single most common surprise for people new to collaborating with git:

```
 ! [rejected]        master -> master (fetch first)
error: failed to push some refs to ...
hint: Updates were rejected because the remote contains work that you do
hint: not have locally.
```

This happens when a teammate pushed while you were working — the remote moved
forward, your branch moved forward, and now the two histories have **diverged**.
This kata teaches you how to read that situation and resolve it calmly.

## Setup

```sh
$ source setup.sh
```

> NOTE: If running setup.sh on windows, run `./setup.sh` instead of sourcing it.

You get an `exercise/` clone. Unbeknownst to you, a teammate has already pushed a
commit to the remote since you cloned.

## The task

1. Make your own change: append `3. Serve hot` to `recipe.txt`, then
   `git commit -am "Add serving step"`.
2. Try to publish it with `git push`. Read the error carefully — why does git
   reject it? (Your push would erase the teammate's commit, so git refuses.)
3. Update your view of the remote with `git fetch`.
4. Run `git status`. It now reports that your branch and `origin/master` have
   **diverged** — "have 1 and 1 different commits each". Visualise it with
   `git log --oneline --graph --all`.

   You have two ways to integrate. We'll try **both** on this same divergence —
   without pushing in between — so you can compare the shape each one produces.

   First, **rebase**, which keeps history linear by replaying your commit on top
   of the teammate's.

5. Run `git pull --rebase`. What does the output say it is doing?
6. Run `git log --oneline --graph --all`. Notice your commit now sits **on top
   of** the teammate's commit — no merge commit, one straight line.

   Now let's see the other option — **merge** (the default for `git pull`) — by
   rewinding to the diverged state and integrating the other way.

7. Return to exactly where you were before the rebase:
   `git reset --hard ORIG_HEAD`. (`ORIG_HEAD` is a bookmark git sets to your
   previous position whenever an operation like pull/rebase/merge moves you — a
   handy one-step undo.) Run `git status`: you're **diverged again**, "ahead 1,
   behind 1".
8. Integrate by merging this time: `git pull --rebase=false` (accept the default
   merge message).
9. Look at `git log --oneline --graph --all`. This time git created a **merge
   commit** with two parents, joining the two lines. Both approaches are valid —
   rebase gives a linear history, merge preserves the exact shape of what happened.
10. `git push` to finish. It succeeds because your merge commit already contains
    the teammate's work, so it's a fast-forward for the remote.

As a bonus: configure `git config pull.rebase true` so `git pull` rebases by
default, and read what `git config pull.ff only` would do instead (refuse to
create merge commits, forcing you to choose explicitly).

## Useful commands

```shell
git fetch                 # See what the remote has without changing your files
git status                # Tells you when you are ahead / behind / diverged
git pull --rebase         # Integrate by replaying your commits (linear history)
git pull --rebase=false   # Integrate by merging (creates a merge commit)
git reset --hard ORIG_HEAD # Undo the last pull/rebase/merge, back to your prior position
git log --oneline --graph --all   # See how the two histories relate
git config pull.rebase true       # Make rebase the default for git pull
```
