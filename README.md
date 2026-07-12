# Git

> A set of git exercises

For more exercises and detailed explanations, you can refer to the [git-katas repository](https://github.com/eficode-academy/git-katas) by Eficode Academy.

## Exercises

Each exercise is a self-contained folder. Run its setup script and follow the
`README.md`:

```sh
$ cd 01_basic_staging
$ source setup.sh
```

The exercises are grouped into a suggested learning path. You can do them in any
order, but within a module later exercises assume the earlier ones.

### A — Foundations

| Exercise | What you learn |
|----------|----------------|
| [01_basic_staging](01_basic_staging) | The staging area: `add`, `status`, `diff` |
| [02_basic_commit](02_basic_commit) | Making commits |
| [03_basic_branching](03_basic_branching) | Creating and switching branches |
| [04_amend](04_amend) | Fixing the last commit with `--amend` |
| [32_gitignore_untracking](32_gitignore_untracking) | `.gitignore` and untracking committed files |

### B — Merging & rewriting history

| Exercise | What you learn |
|----------|----------------|
| [05_ff_merging](05_ff_merging) | Fast-forward merges |
| [08_merge_conflict](08_merge_conflict) | Resolving a merge conflict between two local branches |
| [09_cherry-pick](09_cherry-pick) | Copying a commit with `cherry-pick` |
| [11_rebase_branch](11_rebase_branch) | Rebasing a branch |
| [12_interactive_rebase](12_interactive_rebase) | Reordering, squashing and rewording with `rebase -i` |
| [13_squashing](13_squashing) | Squashing commits |
| [16_reverted_merge](16_reverted_merge) | Reverting (and re-doing) a merge |

### C — Undo, recovery & context-switching

| Exercise | What you learn |
|----------|----------------|
| [06_basic_revert](06_basic_revert) | Undoing a commit with `revert` |
| [07_detached_head](07_detached_head) | Understanding detached HEAD |
| [15_commit_on_wrong_branch](15_commit_on_wrong_branch) | Moving a commit to the right branch |
| [19_save_my_commit](19_save_my_commit) | Recovering lost commits with the reflog |
| [30_stash](30_stash) | Setting work aside with `stash` |
| [31_abort_operations](31_abort_operations) | Backing out of a merge / rebase / cherry-pick |
| [23_worktrees](23_worktrees) | Multiple branches checked out at once with worktrees |

### D — Collaboration (working together over a remote)

| Exercise | What you learn |
|----------|----------------|
| [24_remotes_and_tracking](24_remotes_and_tracking) | Remotes, `fetch` vs `pull`, tracking branches |
| [25_diverged_push](25_diverged_push) | The "rejected push" and how to recover |
| [26_collaborative_conflict](26_collaborative_conflict) | Resolving a conflict that arrived from the remote |
| [27_force_with_lease](27_force_with_lease) | Rewriting shared history safely |
| [28_pull_request_workflow](28_pull_request_workflow) | The full pull-request loop (with a local Gitea server) |
| [29_fork_and_upstream](29_fork_and_upstream) | Forks and keeping in sync with upstream |

> These run against an **isolated remote** — a local bare repository, so nothing
> leaves your machine. If you'd like a *real* server, `utils/serve-remote.sh`
> spins up git's built-in daemon on `localhost`, and
> [28_pull_request_workflow](28_pull_request_workflow) uses a local
> [Gitea](https://about.gitea.com/) server (via `utils/gitea/`) for a genuine
> pull-request UI. Both are optional and fully offline.

### E — Investigation & archaeology

| Exercise | What you learn |
|----------|----------------|
| [17_bisect](17_bisect) | Finding a bad commit with `bisect` |
| [20_investigation](20_investigation) | How git stores objects |
| [33_blame_and_pickaxe](33_blame_and_pickaxe) | `blame` and the `log -S`/`-G` pickaxe |

### F — Advanced & specialized

| Exercise | What you learn |
|----------|----------------|
| [10_tags](10_tags) | Tagging releases |
| [21_signed-commits](21_signed-commits) | Signing commits with GPG |
| [18_submodules](18_submodules) | Embedding repositories with submodules |
| [22_lfs](22_lfs) | Large files with Git LFS |
| [34_rerere](34_rerere) | Reusing recorded conflict resolutions |
| [35_hooks](35_hooks) | Automating checks with git hooks |

## Initial set-up

```sh
$ git config --global user.name "Jeroen Rinzema"
$ git config --global user.email "jeroen@rinzema.dev"
```

> Git configurations could be applied to local applications by removing the `global` flag.

```sh
$ git help <command>
```

## Cheatsheet

A collection of useful commands to use throughout the exercises:

```shell
# Initializing an empty git repository.
git init            # Initialize an empty git repository under current directory.

# Cloning a repository
git clone https://github.com/jeroenrinzema/git.git      # Clone this repository to your current working directory

# Git (user and repo level) configurations
git config --local user.name "Repo-level Username"          # For setting a local git repo level user name.
git config --local user.email "Repo-level.Email@Example.com" # For setting a local git repo level user email.
                                                            # --global -> User level git config stored in <user-home>/.gitconfig for e.g. ~/.gitconfig
                                                            # --local -> repo level config stored in repo's main dir under .git/config


# See local changes
git status                  # Show the working tree status
git diff                    # Show changes current working directory (not yet staged)
git diff --cached           # Show changes currently staged for commit

# Add files to staging (before a commit)
git add myfile.txt          # Add myfile.txt to stage
git add .                   # Add entire working directory to stage

# Make a commit
git commit                              # Make a new commit with the changes in your staging area. This will open an editor for a commit message.
git commit -m "I love documentation"    # Make a new commit with a commit message from the command line
git commit -a                           # Make a new commit and automatically "add" changes from all known files
git commit -am "I still do!"            # A combination of the above
git commit --amend                      # Re-do the commit message of the previous commit (don't do this after pushing!)
                                        #   We _never_ change "public history"
git reset <file>                        # Unstage a staged file leaving in working directory without losing any changes.
git reset --soft [commit_hash]          # resets the current branch to <commit>. Does not touch the staging area or the working tree at all.
                                        # --hard mode would discard all changes.

# Configuring a different editor
## Avoid Vim but stay in terminal:
- `git config --global core.editor nano`

## For Windows:
- Use Notepad:
`git config --global core.editor notepad`

- or for instance Notepad++:
`git config --global core.editor "'C:/Program Files/Notepad++/notepad++.exe' -multiInst -notabbar -nosession -noPlugin"`


# See history
git log             # Show commit logs
git log --oneline   # Formats commits to a single line (shorthand for --pretty=oneline  --abbrev-commit )
git log --graph     # Show a graph commits and branches
git log --pretty=fuller     # To see commit log details with author and committer details, if any different.
git log --follow <file>     # List the history of a file beyond renames
git log branch2..branch1    # Show commits reachable from branch1 but not from branch2

# Deferring
git stash                               # Stash (store temporarily) changes in working branch and enable checkingout a new branch
git stash list                          # List stored stashes.
git stash apply <stash>                 # Apply given <stash>, or if none given the latest from stash list.


# Working with Branches
git branch my-branch       # Create a new branch called my-branch
git switch my-branch     # Switch to a different branch to work on it
git switch -c my-branch  # Create a new branch called my-branch AND switch to it
git branch -d my-branch    # Delete branch my-branch that has been merged with master
git branch -D my-branch    # Forcefully delete a branch my-branch that hasn't been merged to master

# Merging
git merge master         # Merge the master branch into your currently checked out branch.
git rebase master        # Rebase current branch on top of master branch

# Working with Remotes
git remote                  # Show your current remotes
git remote -v               # Show your current remotes and their URLs
git push                    # Publish your commits to the upstream master of your currently checked out branch
git remote add origin <url> # Add a remote called origin with the given url
git push -u origin my-branch  # Push newly created branch to remote repo setting up to track remote branch from origin.
                              # No need to specify remote branch name, for e.g., when doing a 'git pull' on that branch.
git pull                # Pull changes from the remote to your currently checked out branch

# Re/moving files under version control
git rm <path/to/the/file>                 # remove file and stage the change to be committed.
git mv <source/file> <destination/file>   # move/rename file and stage the change to be committed.

# Aliases - it's possible to make aliases of frequently used commands
#   This is often done to make a command shorter, or to add default flags

# Adding a shorthand "sw" for "switch"
git config --global alias.sw "switch"
# Usage:
git sw master     # Does a "git switch master"

## Logging
git log --graph --oneline --all # Show a nice graph of the previous commits
## Adding an alias called "lol" (log oneline..) that shows the above
git config --global alias.lol "log --graph --oneline --all"
## Using the alias
git lol     # Does a "git log --graph --oneline --all"
```
