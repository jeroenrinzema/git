# Git Kata: Under the Hood — Git Objects

Almost every git command you've run so far is a thin layer over a tiny key–value
store. Understanding that store demystifies the whole tool: once you can see the
objects, branches, tags, staging and "detached HEAD" all stop being magic.

Git stores four kinds of objects, each addressed by the SHA-1 hash of its
contents:

| Object   | What it is                                                              |
|----------|------------------------------------------------------------------------|
| **blob** | The raw contents of one file (no name, no path — just bytes).           |
| **tree** | A directory listing: names → (mode, blob/tree hash). This is the shape. |
| **commit** | A snapshot: points at one **tree**, plus parent(s), author, message. |
| **tag**  | An annotated tag object pointing at another object.                     |

Objects live in `.git/objects/`, in subfolders named by the first two hex chars
of the hash — `fc1da6e8f…` is the file `.git/objects/fc/1da6e8f…`.

Two plumbing commands let you read them directly:

- `git cat-file -p <ref>` — pretty-print the object a ref points at (a hash,
  `HEAD`, a branch name, `HEAD:path/to/file`, …).
- `git cat-file -t <ref>` — print its **type** (blob / tree / commit / tag).
- `git ls-tree <ref>` — list the entries of the tree at `<ref>` (add a path to
  descend into a subfolder).

## Setup

```sh
$ source setup.sh
```

You get a repo with **four commits** that build up this working tree:

```
test.md
src/
├── file.c
└── main/
    └── main.h
```

## The task

Your goal: **draw the entire object graph by hand**, using only the plumbing
commands — no `git log`, no peeking at the working directory. By the end you
should have a diagram of commits → trees → blobs.

A suggested path:

1. Start at the tip. What does `HEAD` point at, and what type is it?

   ```sh
   git cat-file -t HEAD
   git cat-file -p HEAD
   ```

   Note the `tree` line and the `parent` line in the output.

2. Follow the `tree` hash from that commit into `git cat-file -p <tree-hash>`
   (or `git ls-tree HEAD`). What entries does the root tree hold? Which are
   `blob`s and which are `tree`s?
3. Descend: `git ls-tree HEAD src` and then into `src/main`. Keep following tree
   hashes down to the blobs.
4. Read a blob's actual bytes: `git cat-file -p HEAD:src/main/main.h`. Confirm the
   hash of that blob matches what the tree entry listed.
5. Now walk **backwards** in history: follow the `parent` hash from step 1 to the
   previous commit, and repeat. Notice how commits that didn't touch a file
   **reuse the exact same blob and tree hashes** — git stores each unique content
   only once (this is why branching and committing are so cheap).

As you go, sketch it:

```
commit(D) ── tree ──┬── test.md      (blob)
   │                └── src/ (tree) ──┬── file.c (blob)
   ▼ parent                          └── main/ (tree) ── main.h (blob)
commit(C) ── tree ── …   (which blobs/trees are shared with D?)
   ▼
commit(B) …
   ▼
commit(A) …
```

### Questions to answer from your diagram

- How many **distinct** blob objects exist across all four commits? How many trees?
- When you added data to `main.h` in one commit, which objects changed and which
  were reused unchanged?
- Where does the branch `master` point, and where does `HEAD`? (Look at
  `.git/refs/heads/master` and `.git/HEAD` — they're just text files.)

## Useful commands

```shell
git cat-file -t <ref>          # Type of the object (blob/tree/commit/tag)
git cat-file -p <ref>          # Pretty-print the object's contents
git cat-file -s <ref>          # Size of the object in bytes
git ls-tree <ref> [<path>]     # List a tree's entries (optionally descend a path)
git rev-parse HEAD             # Resolve a ref to its full hash
git log --oneline --graph      # (Afterwards) check your hand-drawn graph against git's
```
