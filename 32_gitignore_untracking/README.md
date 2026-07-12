# Git Kata: `.gitignore` and Untracking Files

A shared repository should contain **source**, not generated files, local config,
or secrets. `.gitignore` tells git which paths to leave alone. But there's a catch
that trips up every team: **`.gitignore` only affects untracked files.** If
something is already committed, ignoring it does nothing — you have to untrack it
first.

## Setup

```sh
$ source setup.sh
```

> NOTE: If running setup.sh on windows, run `./setup.sh` instead of sourcing it.

You get an `exercise` repo where a previous commit accidentally added build
artifacts (`app.pyc`, `build/app.o`) and a secrets file (`.env`). There's also an
untracked `debug.log`.

## The task

1. Run `git status`. Only `debug.log` shows up as untracked — the mistakenly
   committed files are already tracked, so git doesn't flag them.
2. Create a `.gitignore` in the repo root with rules for the things that don't
   belong in version control:

   ```gitignore
   *.pyc
   *.log
   build/
   .env
   ```

3. Run `git status` again. `debug.log` is now gone from the output — ignored.
   Stage and commit the `.gitignore` itself (`git add .gitignore` — it *should*
   be committed and shared).
4. But `app.pyc`, `build/app.o` and `.env` are **still tracked** and would still
   be pushed. Confirm with `git ls-files` — they're listed despite matching
   `.gitignore`.
5. Untrack them **without deleting them from disk** using `git rm --cached`:

   ```sh
   git rm --cached app.pyc build/app.o .env
   ```

   (The files stay in your working directory; git just stops tracking them.)
6. Run `git status`. The files now show as **deleted** (from git's view) and,
   because they match `.gitignore`, they will *not* reappear as untracked.
7. Commit the cleanup: `git commit -m "Stop tracking build output and secrets"`.
8. Verify with `git ls-files` that only `app.py` and `.gitignore` remain tracked,
   yet the ignored files still physically exist (`ls -a`).

As a bonus:
- Add a line to `.env` and confirm `git status` stays clean — proof it's ignored.
- Learn the escape hatch: force-add an ignored file on purpose with
  `git add -f <file>`.
- Use `git check-ignore -v build/app.o` to see **which** rule is ignoring a path
  — invaluable when a `.gitignore` isn't behaving.

> :warning: A secret that was ever committed still lives in history. Untracking
> stops future exposure, but for a real leak you must also rotate the secret and
> scrub history (e.g. `git filter-repo`). Prevention via `.gitignore` beats cure.

## Useful commands

```shell
git status                    # Untracked/ignored files behaviour
git ls-files                  # List everything git currently tracks
git rm --cached <file>        # Stop tracking a file, keep it on disk
git check-ignore -v <path>    # Show which .gitignore rule matches a path
git add -f <file>             # Force-add a file that .gitignore would skip
```
