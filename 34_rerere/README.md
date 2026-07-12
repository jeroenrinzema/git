# Git Kata: `rerere` — Reuse Recorded Resolution

When a feature branch lives for a while, you often merge or rebase against a
moving `main` repeatedly — and hit **the same conflict every time**, resolving it
by hand over and over. `rerere` ("reuse recorded resolution") records how you
resolved a conflict once and **replays that resolution automatically** the next
time the identical conflict appears.

## Setup

```sh
$ source setup.sh
```

> NOTE: If running setup.sh on windows, run `./setup.sh` instead of sourcing it.

You get an `exercise` repo on `master` with a `topic` branch that conflicts with
`master` on the same line of `app.py`.

## The task

1. Enable rerere for this repository:
   `git config rerere.enabled true`.
2. On `master`, merge the topic branch: `git merge topic`. It conflicts in
   `app.py`. Notice git prints `Recorded preimage for 'app.py'` — rerere is now
   watching.
3. Resolve the conflict: edit `app.py` to the value you want (say
   `greeting = 'hi there'`), then `git add app.py`. Notice git says
   `Recorded resolution for 'app.py'` — your fix is now remembered.
4. Finish the merge with `git commit`, then look at `git log --oneline`.

   Now simulate hitting the same conflict again — as you would on the next rebase
   of a long-lived branch.

5. Throw the merge away: `git reset --hard HEAD~1`. You're back on `master`
   before the merge, with the conflict still lurking.
6. Merge again: `git merge topic`. This time, watch the output — git prints
   `Resolved 'app.py' using previous resolution.` **rerere replayed your fix
   automatically.**
7. Run `git diff` / open `app.py` — it already contains `greeting = 'hi there'`,
   resolved. You only need to `git add app.py` and `git commit` to finish. You
   never re-did the merge by hand.

As a bonus:
- Run `git rerere status` during a conflict to see which files rerere is tracking.
- Run `git rerere diff` to see the resolution it recorded.
- Turn it on for **all** repositories once with
  `git config --global rerere.enabled true` — it's a quietly enormous
  time-saver on any long-running branch.

## Useful commands

```shell
git config rerere.enabled true    # Turn on rerere for this repo
git config --global rerere.enabled true   # ...or for every repo
git rerere status                 # Files rerere is currently tracking
git rerere diff                   # The recorded resolution as a diff
git reset --hard HEAD~1           # (used here to replay the same conflict)
```
