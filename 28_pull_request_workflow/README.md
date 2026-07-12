# Git Kata: Pull Request Workflow

Most teams don't push straight to the shared `main` branch. Instead they use the
**pull request** (PR) workflow: you do your work on a feature branch, push it,
open a pull request, a teammate reviews it, and only then is it merged. This kata
walks the full loop against a **real forge with a web UI**.

To keep everything **local and isolated**, we run [Gitea](https://about.gitea.com/)
— a small, self-hosted, GitHub-like server — in Docker. Nothing leaves your
machine. (If you'd rather use a real GitHub repository, see
[_Doing this on GitHub instead_](#doing-this-on-github-instead) at the bottom;
the steps are identical.)

## Setup

```sh
$ source setup.sh
```

This just checks that Docker is installed. Then start the server:

```sh
$ source ../utils/gitea/gitea.sh
$ gitea-up
```

`gitea-up` boots Gitea, creates a training user, and seeds an empty `team-app`
repository. When it finishes it prints your credentials and URLs:

- Web UI: <http://localhost:3300> — user `kata`, password `kata12345`
- Repo: <http://localhost:3300/kata/team-app>

Open the web UI in your browser and log in — you'll watch your PR appear there.

## The task

1. Clone the seeded repository (the credentials are baked into the URL for
   convenience):

   ```sh
   git clone http://kata:kata12345@localhost:3300/kata/team-app.git
   cd team-app
   ```

2. You're on `main`. Confirm with `git branch -vv` that it tracks
   `origin/main`. This is the **shared** branch — we won't commit to it directly.
3. Create a feature branch and switch to it: `git switch -c feature/greeting`.
4. Add a small feature — create `greet.py`:

   ```python
   def greet(name):
       return f"Hello, {name}!"
   ```

   Then `git add greet.py` and `git commit -m "Add greeting helper"`.
5. Publish the branch and set it to track:
   `git push -u origin feature/greeting`.
   Note the hint git prints — Gitea even gives you a URL to open a PR.
6. In the **web UI**, open a pull request from `feature/greeting` into `main`
   (Pull Requests → New Pull Request). Give it a title and description.
   Notice the diff, the commits tab, and that it targets `main`.
7. Review your own PR: add a review comment on a line of `greet.py`. In a real
   team this is where a colleague would give feedback.
8. Simulate acting on feedback: back in your terminal, still on
   `feature/greeting`, improve the code — add a docstring — then
   `git commit -am "Document greet()"` and `git push`.
9. Refresh the PR in the browser. Notice your **new commit appears on the
   existing PR automatically** — you don't open a new PR for follow-up work.
10. Merge the PR using the green **Merge** button in the UI. Look at the merge
    options (merge commit, rebase, squash) — pick "Create merge commit".
11. Back in your terminal, switch to `main` and pull the merged result:

    ```sh
    git switch main
    git pull
    ```

    Confirm `greet.py` is now on `main` and `git log --oneline --graph` shows the
    merge commit.
12. Clean up the merged branch, locally and on the remote:

    ```sh
    git branch -d feature/greeting
    git push origin --delete feature/greeting
    ```

    (Gitea also offers a "Delete branch" button on the merged PR — either works.)
13. Run `git remote prune origin` (or `git fetch --prune`) and confirm the stale
    `origin/feature/greeting` tracking reference is gone.

As a bonus, open a second PR that intentionally conflicts with something already
on `main`, and watch how the UI flags it as "This branch has conflicts that must
be resolved."

## Tear down

When you're done, stop the server:

```sh
$ gitea-down            # stops Gitea, keeps its data
$ gitea-down --purge    # stops Gitea and wipes all data
```

## Doing this on GitHub instead

Every step above maps 1:1 to GitHub. Instead of `gitea-up`, fork or create a repo
on github.com, then:

- Clone your repo, `git switch -c feature/greeting`, commit, and
  `git push -u origin feature/greeting`.
- Open the PR from the GitHub UI (or with the CLI: `gh pr create`).
- Review, push follow-up commits to the same branch, and merge with the
  **Merge** button (or `gh pr merge`).
- `git switch main && git pull`, then delete the branch.

The only difference is the host — the git commands and the PR concept are the same.

## Useful commands

```shell
git switch -c <branch>              # Create and switch to a feature branch
git push -u origin <branch>         # Publish it and set upstream tracking
git push                            # Push follow-up commits onto the same PR
git switch main && git pull         # Get the merged result after the PR lands
git push origin --delete <branch>   # Delete the merged branch on the remote
git fetch --prune                   # Drop stale remote-tracking references
gh pr create / gh pr merge          # (GitHub) do PRs from the command line
```
