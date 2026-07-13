# Git Kata: Submodules

A **submodule** embeds one git repository inside another while keeping the two
histories completely separate. The outer repo (the *superproject*) does **not**
copy the inner repo's files into its own history — it stores a single line: "at
this path, check out **exactly this commit** of that other repo." Think of it as
a typed, version-pinned pointer.

That is the whole mental model, and every surprising thing about submodules
follows from it:

- The superproject tracks a **specific commit**, not "the latest". New commits in
  the inner repo are invisible to the superproject until you deliberately move the
  pointer and commit that move.
- A fresh clone of the superproject gets the pointer but an **empty** submodule
  directory until you `init` and `update` it.

This kata walks both sides of that relationship: publishing a change through a
submodule, and picking it up again from a clone.

## Setup

```sh
$ source setup.sh
```

> NOTE: On Windows, sourcing can misbehave — run `./setup.sh` instead so the
> folders are created correctly.

### ⚠️ One setting you need first

Because this kata uses **local file paths** as stand-in "remotes" (so everything
stays offline), you must allow git's `file` protocol for submodule operations:

```sh
$ git config --global protocol.file.allow always
```

Since git 2.38 this is blocked by default for submodules — a fix for
[CVE-2022-39253](https://github.blog/2022-10-18-git-security-vulnerabilities-announced/).
**Real** submodules use `https`/`ssh` URLs and are unaffected, so this only
matters for local katas like this one. Without it, `git submodule add` fails with
`fatal: transport 'file' not allowed`.

When you finish the kata you can undo it:

```sh
$ git config --global --unset protocol.file.allow
```

## The lay of the land

After setup you have three repositories inside `exercise/`:

| Repo        | What it represents                                                    |
|-------------|-----------------------------------------------------------------------|
| `remote`    | The "server" copy of a shared component (like a repo on github.com).  |
| `component` | A working clone of `remote` — where the component team does its work. |
| `product`   | Your application. You want to *embed* the component into it.          |

You will play both roles: the **product** developer consuming the component, and
the **component** developer publishing a change.

## The task

Work through these and, at each step, pause on the questions — they are the point
of the exercise, not filler.

Start in the **`product`** repository.

1. Add the component as a submodule:
   `git submodule add ../remote include`.
2. Look at your working directory. What new files and folders appeared?
3. Run `git status`. It should show **two** new staged entries — which ones, and
   why is one of them a whole directory rather than the files inside it?
4. `cd include`. Whose repository are you in now? Run `git log` — is this the
   product's history or the component's?
5. Back in `product`, run `git diff --staged`. Find the `+Subproject commit ...`
   line. That hash **is** the pointer. Where else can you see that exact commit?
   (Hint: `git -C include log --oneline`.)
6. Commit the changes in `product` (e.g. `git commit -m "Add include submodule"`).

   Now switch hats and go to the **`component`** repository.

7. Does the component repo know it's being used as a submodule anywhere?
   (Spoiler: no — the relationship is one-directional. Only the superproject
   knows.)
8. Make a change, commit it, and push it:

   ```sh
   touch feature.h
   git add feature.h
   git commit -m "Add feature.h"
   git push
   ```

   Back to the **`product`** repository.

9. Run `git status`, then `git submodule foreach 'git fetch && git status'`. Does
   the product notice the component moved on? (It won't complain — remember, the
   pointer is pinned.)
10. Move into the submodule and pull the new work:
    `cd include && git checkout master && git pull`.
11. Confirm `feature.h` is now present inside `include`.
12. Back in `product`, run `git status` and `git diff`. The submodule now shows as
    **modified** — because its checked-out commit no longer matches the pinned
    pointer. This is the moment to *advance the pointer*: `git add include` then
    `git commit -m "Bump include to latest"`.

    Now let's see what a colleague cloning your product experiences. Go to the
    **`exercise`** directory.

13. Clone your product: `git clone product product_alpha`.
14. `cd product_alpha`. Look at the log (it's there) and at the `include`
    directory. What's inside `include`? (It's **empty** — the clone brought the
    pointer but not the submodule's contents.)
15. Run `git submodule init`. What changed in `include`? (Still empty — `init`
    only registers the submodule's config; it doesn't fetch yet.)
16. Run `git submodule update`. **Now** `include` fills in, checked out at the
    pinned commit. (Tip: `git submodule update --init` does steps 15–16 in one go.)
17. Is `feature.h` available in `product_alpha/include`?

    One more scenario: the pointer moving *without* a fresh clone. Go back to the
    **`product`** repository.

18. Make another change through the submodule and commit the pointer bump in
    `product` — but **don't push `product` yet** (we'll simulate `product_alpha`
    being behind). For example, in `include` create and commit a file, push it,
    then back in `product` do `git add include && git commit`.

    Go to the **`product_alpha`** repository.

19. Run `git submodule update`. Is the newest change available in `include`? Why
    not? (`product_alpha` hasn't pulled `product`'s new pointer, so `update` just
    re-checks-out the commit it already knows.)
20. Run `git submodule status` and compare the hash with the `component` repo's
    latest commit.
21. Now run `git submodule update --remote`. This tells git: ignore the pinned
    commit, fetch the submodule's **tracked branch** and check out its tip.
22. Is the newest change available now? Examine `git submodule status` again — the
    hash should match the component's latest.

> :bulb: `update` (pinned commit) vs `update --remote` (branch tip) is the single
> most important distinction in this kata. The default keeps builds reproducible;
> `--remote` is how you *intentionally* pull the submodule forward.

## Verify

You've understood submodules if you can answer:

- Where is the pinned commit hash recorded? (In the superproject's tree — visible
  via `git diff --staged` / `git submodule status`. Note that `.gitmodules` stores
  only the *path and URL*, **not** the commit.)
- Why is a freshly cloned submodule directory empty, and which two commands fill
  it?
- What's the difference between `git submodule update` and
  `git submodule update --remote`?

As a bonus, try to **draw this entire exercise on paper** — two histories and the
pointer between them.

## Useful commands

```shell
git submodule add <url> <path>        # Embed a repo at <path>, pinned to its current commit
git submodule status                  # Show each submodule's pinned commit and state
git submodule init                    # Register submodules from .gitmodules into .git/config
git submodule update                  # Check out each submodule at its pinned commit
git submodule update --init           # init + update in one step
git submodule update --remote         # Advance submodules to their tracked branch tip
git submodule foreach '<cmd>'         # Run <cmd> in every submodule
git diff [--cached] --submodule       # Show submodule pointer moves as readable log lines
git log -p --submodule                # History including submodule pointer changes
```
