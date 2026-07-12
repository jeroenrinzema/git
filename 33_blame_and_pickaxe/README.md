# Git Kata: Blame & the Pickaxe

When you're working on a codebase with other people, half the job is
understanding *why* a line looks the way it does. Two tools answer that:

- **`git blame`** — for each line of a file, who last changed it, in which commit.
- **The "pickaxe" (`git log -S` / `-G`)** — find the commits where a particular
  string or pattern was **added or removed**, even if the line is long gone.

## Setup

```sh
$ source setup.sh
```

> NOTE: If running setup.sh on windows, run `./setup.sh` instead of sourcing it.

You get an `exercise` repo with a `server.py` that four commits by Alice, Bob and
Carol built up — including a `debug = True` line that was added and later removed.

## The task

### Blame

1. Run `git blame server.py`. For each line you see the commit, author and date
   that last touched it.
2. Who set `port = 9090`, and in which commit? Read it straight off the blame
   output.
3. Blame shows the *last* change to a line. To see the change **before** that,
   take the commit hash from blame and run
   `git blame <hash>^ -- server.py` (the `^` means "the parent"). What was the
   port before it became `9090`?
4. Narrow blame to a range of lines: `git blame -L 1,2 server.py`.

### Pickaxe — find when something appeared and vanished

5. The current `server.py` has no `debug` line, but it was there once. Find every
   commit that added or removed it:

   ```sh
   git log -S debug --oneline
   ```

   You should see **two** commits — the one that introduced `debug` and the one
   that removed it.
6. See exactly what changed in those commits by adding a patch:
   `git log -S debug -p -- server.py`. Read the `+`/`-` lines.
7. `-S` counts occurrences of a string; `-G` matches a regular expression in the
   diff. Try `git log -G 'port = [0-9]+' --oneline` to find every commit that
   changed a port assignment.

### Put them together

8. Imagine "who decided 9090 and was debug still on at that point?" Use blame to
   find the commit that set `9090`, then `git show <hash>` to read the full commit
   — message, author, and the surrounding diff.

As a bonus, try `git log --follow -p -- server.py` to see the file's entire
history as a series of diffs, and `git blame -w` to ignore whitespace-only changes
when hunting for the real author of a line.

## Useful commands

```shell
git blame <file>              # Who last changed each line
git blame -L 1,2 <file>       # Blame only lines 1–2
git blame <commit>^ -- <file> # Blame as of the parent of <commit>
git log -S <string> --oneline # Commits that added/removed <string> (pickaxe)
git log -G <regex> --oneline  # Commits whose diff matches <regex>
git log -S <string> -p        # ...with the diffs shown
git show <commit>             # Full details of one commit
```
