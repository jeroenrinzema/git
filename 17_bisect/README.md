# Git Kata: Bisect — Hunt a Bad Commit

You come back from a week off to bad news: `master` is broken and has been for a
while. Every pull request looked fine on its own, but somewhere in the last dozens
of commits, one of them broke the build — and nobody noticed.

The app is a checkout that computes a cart total. It must always come out to
**42**, and there's a CI check that guards exactly that:

```sh
$ ./test.sh
test passed        # when the total is 42
```

Somewhere in history, a commit changed the total to something else and `test.sh`
started failing. You *could* check out commits one by one and run the test until
you find the culprit — but with a long history that's slow and error-prone.

`git bisect` does it for you with a **binary search**: you tell it one commit that
is *good* (test passes) and one that is *bad* (test fails), and it repeatedly
jumps to the middle of the unknown range, asking "good or bad?" each time. Every
answer halves what's left, so even hundreds of commits are pinned down in a
handful of steps.

Luckily, back when the project started, someone tagged the first commit
`initial-commit` — and we know the build passed there. That's our known-good
anchor.

## Setup

```sh
$ source setup.sh
```

This builds a repo whose current `master` is broken. Run `./test.sh` and see it
fail.

## The task

Find the exact commit that broke the checkout total, using `git bisect`.

### Doing it by hand (understand the loop)

1. Start a bisect session: `git bisect start`.
2. Mark where you are now (the tip) as broken: `git bisect bad`.
3. Mark the known-good anchor: `git bisect good initial-commit`.
4. git now checks out a commit halfway between them and prints how many steps are
   left. Run the test:

   ```sh
   $ ./test.sh
   ```

5. Tell git the result: `git bisect good` if it passed, `git bisect bad` if it
   failed. git jumps to the next midpoint.
6. Repeat step 4–5 until git announces:

   ```
   <hash> is the first bad commit
   ```

   That's your culprit. `git show HEAD` to read what it actually changed — can you
   spot the bug?

### Letting git run the test for you

Once you trust the test to return `0` for good and non-zero for bad, you can hand
the whole loop to git. Reset and let it drive:

```sh
$ git bisect reset          # end the manual session
$ git bisect start
$ git bisect bad
$ git bisect good initial-commit
$ git bisect run ./test.sh  # git runs the test at each step automatically
```

git will bisect the entire range untouched and stop on the first bad commit. This
is the real power move — a scripted `git bisect run` can find a regression in a
huge repo while you get coffee.

## Verify

`git bisect` leaves you checked out on the first bad commit, with a `refs/bisect/bad`
marker. **Run the verify script before you `git bisect reset`** (resetting clears
that marker):

```bash
$ cd ..
$ ./verify.sh
```

When you're done, clean up with `git bisect reset` to return to `master`.

## Useful commands

```shell
git bisect start                 # Begin a bisect session
git bisect bad [<ref>]           # Mark a commit as broken (default: HEAD)
git bisect good <ref>            # Mark a commit as working
git bisect run <cmd>             # Automate: run <cmd> at each step (exit 0 = good)
git bisect reset                 # End the session and return to where you were
git bisect log                   # Show the good/bad answers so far
git bisect --help                # Full manual
```

## If you get stuck

The full automated solution:

```sh
$ git bisect start
$ git bisect bad
$ git bisect good initial-commit
$ git bisect run ./test.sh
```
