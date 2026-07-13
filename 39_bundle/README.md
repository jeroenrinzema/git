# Git Kata: Offline History with `git bundle`

How do you move commits from one repo to another when there's **no network path**
between them — an air-gapped machine, a locked-down environment, or a colleague
you can only reach by USB stick or email attachment?

`git bundle` packages commits into a **single ordinary file**. You copy that file
by any means you like, and on the other side git treats it exactly like a remote:
you can `clone`, `fetch`, or `pull` from the bundle. It's a whole remote,
flattened into one portable file.

This is genuinely useful for: sneakernet transfers, sending a repo as an email
attachment, seeding a repo into an isolated network, or making a compact backup of
just the history.

## Setup

```sh
$ source setup.sh
```

> NOTE: On Windows, run `./setup.sh` instead of sourcing it.

You get a single `project/` repo with a few commits of "field notes" and — by
design — **no remote at all**. Your job is to get its history into a fresh repo
using only a file.

## The task

### Move a whole repo as one file

1. Go into the source repo and bundle its entire history into one file:

   ```sh
   cd project
   git bundle create ../project.bundle --all
   ```

2. Inspect the file — it's just data you could email or copy anywhere. Ask git to
   check it's self-contained:

   ```sh
   git bundle verify ../project.bundle
   ```

   ("The bundle records a complete history" means it needs nothing else to be
   cloned.)
3. Mark the point you've shared so far — you'll need it for the incremental step:

   ```sh
   git tag shared
   ```

4. Now pretend `project.bundle` was carried to another machine. From the kata
   directory, **clone from the file** as if it were a server:

   ```sh
   cd ..
   git clone project.bundle laptop
   ```

5. `cd laptop` and look around: `git log --oneline` shows the full history, and
   `git remote -v` reveals that `origin` is literally the bundle file. A bundle is
   a first-class remote.

### Send only the new work (an incremental bundle)

Copying the whole repo every time is wasteful. Bundles can carry **just the new
commits** since a point the receiver already has.

6. Back in `project`, do some more work:

   ```sh
   cd ../project
   echo "- day 3: found water" >> notes.md && git commit -am "Day 3"
   echo "- day 4: built shelter" >> notes.md && git commit -am "Day 4"
   ```

7. Bundle **only** the commits after the `shared` marker:

   ```sh
   git bundle create ../update.bundle shared..master
   ```

   This records that the receiver must already have the `shared` commit as a
   *prerequisite* — the bundle is tiny, just the delta.
8. Carry `update.bundle` to the laptop and apply it:

   ```sh
   cd ../laptop
   git bundle verify ../update.bundle    # confirms you have the prerequisite commit
   git pull ../update.bundle master
   ```

9. Run `git log --oneline` in `laptop` — Day 3 and Day 4 arrived, with no network
   involved. You just did an "offline push" with a file.

> :bulb: A bundle made with `--all` is a perfect **single-file backup** of a
> repo's history, and `<basis>..<tip>` incremental bundles are how you'd
> repeatedly sync an air-gapped mirror — bundle the delta, sneakernet it across,
> `git pull` it in.

## Verify

```bash
$ cd ..
$ ./verify.sh
```

## Useful commands

```shell
git bundle create <file> --all          # Bundle every ref (a full backup)
git bundle create <file> <branch>       # Bundle a single branch's history
git bundle create <file> <base>..<tip>  # Incremental: only commits after <base>
git bundle verify <file>                # Check a bundle and its prerequisites
git clone <file> <dir>                  # Clone from a bundle as if it were a remote
git fetch <file> <branch>               # Fetch from a bundle into an existing repo
git pull <file> <branch>                # Fetch + integrate from a bundle
```
