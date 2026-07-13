# Git Kata: Patches & the Email Workflow (`apply`, `format-patch`, `am`)

Not every project lives on a forge like GitHub. The **Linux kernel**, **git
itself**, PostgreSQL, and countless others are still developed over **email**:
a contributor mails a patch to a mailing list, a maintainer reviews it in their
inbox and applies it. This isn't legacy trivia — it's how some of the most
important software in the world ships *today*, and git has first-class support
for it.

Underneath, a "patch" is nothing exotic: it's just the **text** of a diff. Once
you see that, three commands unlock the whole workflow:

| Command             | What it does                                                        |
|---------------------|---------------------------------------------------------------------|
| `git apply`         | Replay a raw diff onto your working tree. No commit, no author.      |
| `git format-patch`  | Turn commits into email-ready `.patch` files (author, message, diff).|
| `git am`            | "Apply mailbox" — replay those files as real commits, keeping authorship. |

This is also handy any time you need to move a change around **without a remote**
— hand it to a colleague, carry it on a USB stick, or attach it to a ticket.

## Setup

```sh
$ source setup.sh
```

> NOTE: On Windows, run `./setup.sh` instead of sourcing it.

You get two ordinary repositories, no remote between them:

- `upstream/` — the maintainer's project (a tiny `calc.py`), maintained by
  *Maria Maintainer*.
- `exercise/` — **your** clone. You are the contributor. You start here.

## The task

### Part 1 — a patch is just text

1. In `exercise`, make a change *without committing* — add a docstring to
   `add()` in `calc.py`:

   ```python
   def add(a, b):
       """Return the sum of a and b."""
       return a + b
   ```

2. Run `git diff`. **This text is the patch.** Save it to a file:

   ```sh
   git diff > fix.patch
   ```

   Open `fix.patch` and read it: the `diff --git` line, the `---`/`+++` file
   markers, and the `@@ ... @@` **hunk header** telling git where the change goes.
3. Throw your working change away: `git restore calc.py`. Confirm the docstring is
   gone.
4. Now replay the saved text onto the clean file:

   ```sh
   git apply --stat fix.patch    # preview: which files/lines change
   git apply --check fix.patch   # dry-run: would it apply cleanly?
   git apply fix.patch           # actually apply it
   ```

   The docstring is back. Note what `apply` did **not** do: it didn't create a
   commit and it recorded no author — it only edited your working tree. A raw
   diff carries *changes*, not *history*.

### Part 2 — email-ready patches with `format-patch`

5. Commit your fix: `git commit -am "Document add()"`.
6. Add a second commit — a `mul()` function in `calc.py`:

   ```python
   def mul(a, b):
       """Return the product of a and b."""
       return a * b
   ```

   `git commit -am "Add mul()"`.
7. Produce emailable patches for everything you've done since upstream:

   ```sh
   git format-patch origin/master
   ```

   You get one numbered file per commit: `0001-Document-add.patch`,
   `0002-Add-mul.patch`.
8. Open `0001-Document-add.patch`. It's a **complete email**:

   ```
   From <hash> Mon Sep 17 00:00:00 2001
   From: Your Name <you@example.com>
   Date: ...
   Subject: [PATCH 1/2] Document add()

   <commit body, if any>
   ---
    calc.py | 1 +
   ...
   ```

   The `From`, `Subject: [PATCH n/m]` and message are all there — this is exactly
   what a tool like `git send-email` would drop into a mailing list.

### Part 3 — the maintainer applies them with `git am`

9. Switch roles. Go to the maintainer's repo: `cd ../upstream`. Imagine these two
   patches just arrived in Maria's inbox.
10. Apply the whole series in order:

    ```sh
    git am ../exercise/0*.patch
    ```

11. Run `git log --pretty="%h %an: %s"`. The new commits are there — and they're
    authored by **you**, the contributor, with your original messages, not by the
    maintainer. That's the key difference from `git apply`: `am` recreates real
    commits and **preserves authorship**, which is why it's the receiving end of
    the email workflow.
12. Confirm `calc.py` in `upstream` now has both `add()`'s docstring and `mul()`.

> :bulb: **This is how mailing-list projects work today.** A contributor runs
> `git format-patch` then `git send-email` to post the series to a list (e.g.
> the kernel's lists, archived at [lore.kernel.org](https://lore.kernel.org)).
> Maintainers and reviewers reply inline to the patch text, and once accepted a
> maintainer runs `git am` to land it. No pull requests, no forge — just git and
> email.

If a patch doesn't apply cleanly, `git am` stops mid-series just like a rebase.
Your escape hatches are `git am --abort` (bail out entirely) or `git am --3way`
(let git do a smarter three-way merge using the blobs the patch references).

## Verify

```bash
$ cd ..
$ ./verify.sh
```

## Useful commands

```shell
git diff > patch.txt          # A patch is just the text of a diff
git apply <file>              # Replay a diff onto the working tree (no commit)
git apply --check <file>      # Dry-run: will it apply cleanly?
git apply --stat <file>       # Preview which files/lines change
git format-patch <base>       # One email-ready .patch file per commit since <base>
git format-patch -1 <ref>     # Just one commit
git am <file>...              # Apply patch files as commits, preserving authorship
git am --abort                # Bail out of a failed patch series
git am --3way                 # Apply with a three-way merge when it won't apply cleanly
git send-email <file>...      # (optional) Mail a patch series to a list
```
