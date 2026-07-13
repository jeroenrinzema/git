# Git Kata: Scrubbing a Secret from History with `git filter-repo`

Someone committed a secrets file a few commits ago. You can `git rm` it today,
but that only removes it *going forward* — the file (and the live API key inside
it) still sits in **every historical commit**, visible to anyone with the repo via
`git log`, `git show`, or a clone. To truly remove it you have to **rewrite
history**.

The modern tool for this is **`git filter-repo`**. It replaces the old, slow, and
footgun-prone `git filter-branch` (git's own docs now recommend against
`filter-branch`), and it's much easier to drive than the alternative
[BFG Repo-Cleaner](https://rtyley.github.io/bfg-repo-cleaner/).

> ⚠️ **The most important lesson first:** rewriting history does **not** un-leak a
> secret. Anyone who already cloned or read it still has it. A leaked credential
> must be treated as compromised — **rotate/revoke it** regardless of what you do
> to the repo. History rewriting is cleanup, not damage control.

## Getting ready

`git filter-repo` is not bundled with git — install it once (like Git LFS):

```sh
brew install git-filter-repo        # macOS
pip install git-filter-repo         # any platform with Python
# or download the single script from https://github.com/newren/git-filter-repo
```

Check it's available: `git filter-repo --version`.

## Setup

```sh
$ source setup.sh
```

> NOTE: On Windows, run `./setup.sh` instead of sourcing it.

You get a repo where an early commit ("Add service config") added a `secret.env`
containing a fake API key and DB password, with more commits piled on top.

## The task

### See the leak

1. Confirm the secret is live and buried in history:

   ```sh
   git log --oneline
   cat secret.env                       # the current leak
   git log --all --oneline -- secret.env  # every commit that touched it
   ```

2. Convince yourself that deleting it *now* wouldn't be enough: the file is in
   past commits, so `git show <that-commit>:secret.env` would still print the key
   forever. This is why we must rewrite history, not just delete the file.

### Scrub it from all history

3. Remove `secret.env` from **every** commit:

   ```sh
   git filter-repo --path secret.env --invert-paths --force
   ```

   - `--path secret.env` selects the file, `--invert-paths` means "keep everything
     *except* this" — so the file is stripped from all history.
   - `--force` is needed here because our `exercise` repo isn't a fresh clone.
     filter-repo *deliberately* refuses to rewrite a working repo by default, to
     stop you destroying data by accident — in real life you'd run it on a fresh
     `git clone --mirror` and re-push. (Try it without `--force` first to see the
     guardrail.)

4. Verify the secret is truly gone from history:

   ```sh
   git log --all --oneline -- secret.env    # prints nothing now
   git log --oneline                        # commits rewritten, new hashes
   git rev-list --all --objects | grep secret.env   # no match
   ```

   Notice the commit that *only* added `secret.env` has vanished entirely — with
   nothing left in it, filter-repo dropped it as empty. You'll also see git no
   longer has an `origin` remote: filter-repo removes it on purpose so you can't
   accidentally push the rewrite before you're ready.

### Finish the job (in real life)

5. Because every commit hash changed, this is a **history rewrite**. On a shared
   repo you'd now force-push (`git push --force-with-lease --all` and `--tags`)
   and tell every teammate to re-clone or hard-reset — their old clones still
   contain the secret. And, again: **rotate the leaked key.**

> :bulb: Want to keep a file but redact a string inside it (e.g. a token pasted
> into a config you still need)? Use `--replace-text`: put
> `sk_live_51H8xLeaked1234567890abcdef==>REDACTED` in a file and run
> `git filter-repo --replace-text <that-file>`. It rewrites the string across all
> history while leaving the file in place.

## Verify

```bash
$ cd ..
$ ./verify.sh
```

## Useful commands

```shell
git filter-repo --path <p> --invert-paths   # Strip path <p> from all history
git filter-repo --path <p>                   # Keep ONLY <p> (extract a subdirectory)
git filter-repo --replace-text <file>        # Redact strings across all history
git log --all --oneline -- <path>            # Every commit that touched <path>
git rev-list --all --objects | grep <path>   # Is a path still reachable anywhere?
git push --force-with-lease --all            # Publish the rewrite (coordinate first!)
```
