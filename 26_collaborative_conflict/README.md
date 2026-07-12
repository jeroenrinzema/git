# Git Kata: Collaborative Merge Conflict

Kata 08 taught you conflicts between two of *your own* branches. In a team, the
more common case is a conflict that arrives **from the remote**: you and a
teammate changed the same lines, and git can't decide whose version wins. This
kata reproduces that and walks you through resolving it.

## Setup

```sh
$ source setup.sh
```

> NOTE: If running setup.sh on windows, run `./setup.sh` instead of sourcing it.

You get an `exercise/` clone containing a `config.yml`. A teammate has already
pushed a change to one of its lines.

## The task

1. Look at `config.yml`. You need to change the `port` — edit the line
   `port: 8080` to `port: 3000`, then `git commit -am "Move app to port 3000"`.
2. Publish it with `git push`. It is **rejected** — the remote moved on. (If this
   step is unfamiliar, do kata 25 _Diverged Push_ first.)
3. Run `git pull`. Because you *both* edited the `port` line, git stops with a
   **merge conflict**:

   ```
   CONFLICT (content): Merge conflict in config.yml
   ```

4. Run `git status`. It lists `config.yml` under "Unmerged paths". Open the file
   and find the conflict markers:

   ```
   <<<<<<< HEAD
   port: 3000
   =======
   port: 9090
   >>>>>>> <hash> (Teammate: move app to port 9090)
   ```

   - `<<<<<<< HEAD` … `=======` is **your** version.
   - `=======` … `>>>>>>>` is the **teammate's** version.

5. Resolve it by hand: decide the final value (say you agree on `port: 9090`),
   and delete the three marker lines so the file is valid again.
6. Mark it resolved and finish the merge:

   ```sh
   git add config.yml
   git commit          # accept the default merge message
   ```

7. Run `git log --oneline --graph` and confirm the merge commit ties both lines
   of work together. **Don't push yet** — try the rebase alternative first.

   Bonus — a cleaner history via rebase (do this *before* pushing):

8. Undo the merge to replay the scenario: `git reset --hard HEAD~1`. You're back
   on your own commit, with the teammate's change still unmerged.
9. Integrate with rebase instead: `git pull --rebase`. You hit the **same
   conflict**, because you both touched the `port` line. Resolve `config.yml` the
   same way, then continue with:

   ```sh
   git add config.yml
   git rebase --continue
   ```

   Look at `git log --oneline --graph` — this time there's **no merge commit**,
   just your change replayed on top of the teammate's.
10. If a rebase ever gets too messy, remember you can bail out entirely with
    `git rebase --abort` and be back exactly where you started.
11. Finally, publish your resolved work with `git push`. It succeeds now that you
    have integrated the teammate's change.

## Useful commands

```shell
git status                    # Shows "Unmerged paths" during a conflict
git diff                      # Shows the conflicting hunks
git add <file>                # Mark a conflict as resolved
git merge --continue          # (or `git commit`) finish a conflicted merge
git rebase --continue         # Finish a conflicted rebase
git merge --abort             # Bail out of a conflicted merge
git rebase --abort            # Bail out of a conflicted rebase
```
