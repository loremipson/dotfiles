---
name: diagnose
description: Diagnosis loop for hard bugs and performance regressions. Use when asked to debug or diagnose, or when something is broken, throwing, failing, flaky, or slow and the cause isn't obvious.
---

# Diagnose

Find the root cause with evidence, then fix it once in the shared code. Phases run in order. Skip one only with a stated reason.

Redact secrets in everything you show. Build commands against env vars so credentials stay out of the transcript.

## 1. Build a red loop

This is the whole skill. Get one command that goes **red** on this exact bug. Then bisection, hypotheses, and instrumentation all just consume it. Without one, reading code produces theories, not answers.

Try these roughly in order:

1. A failing Vitest test at whatever seam reaches the bug.
2. A curl or script against the running dev server.
3. A CLI or script call with a fixture input, diffed against known-good output.
4. A Playwright script that drives the UI and asserts on DOM, console, or network.
5. A captured request or event replayed through the code path in isolation.
6. A throwaway harness that boots the smallest slice of the system with one function call.
7. A loop over many random inputs, for "sometimes wrong" bugs.
8. A `git bisect run` script, when it worked at a known earlier state.
9. A differential run: same input through old and new versions, diffed.

Then make it **tight**: seconds not minutes, same verdict every run, asserting the user's exact symptom rather than "didn't crash". For flaky bugs, raise the reproduction rate (loop it, add load, narrow timing) until it's high enough to work against.

Done when you have shown one command, its invocation, and its red output. If you can't build one, stop and say what you tried. Ask for access to the failing environment, a captured artifact (HAR, log dump, recording), or permission to add temporary instrumentation. Don't move on to theories without a loop.

## 2. Reproduce and minimize

Confirm the loop shows the failure the user described, not a nearby one. Then cut inputs, data, config, and steps one at a time, rerunning after each cut. Done when every remaining piece is load-bearing: removing any one turns the loop green.

## 3. Hypothesize

Write 3 to 5 ranked hypotheses before testing any. Each makes a falsifiable prediction: "If X is the cause, changing Y makes it disappear." A hypothesis without a prediction is a vibe, so sharpen it or drop it. Show the ranked list to the user, who often knows something that reorders it, then continue with your ranking without waiting.

## 4. Instrument

Each probe tests one prediction and changes one variable. Prefer a debugger or REPL, then targeted logs at the boundaries that separate hypotheses. Tag every debug log with a unique prefix like `[DEBUG-a4f2]` so cleanup is one grep. For performance, measure a baseline first (timing harness, profiler, `EXPLAIN ANALYZE`), then bisect against it.

## 5. Fix at the root

Ask why until you reach the cause, and fix it there. A null check that silences the crash is a symptom guard, not a fix. Before editing, grep every caller of the function you're changing.

Turn the minimized repro into a regression test at a seam that exercises the real bug pattern. Watch it fail, apply the fix, watch it pass, then rerun the original phase 1 loop. If no seam can catch the bug honestly, say so. That's an architecture finding worth reporting.

If two fixes built on the same assumption have both failed, stop fixing. Question the assumption itself.

## 6. Clean up

- [ ] The original loop is green.
- [ ] The regression test passes, or the missing seam is reported.
- [ ] `grep` for the debug prefix returns nothing.
- [ ] Throwaway harnesses are deleted.
- [ ] The confirmed hypothesis goes in the suggested commit message, so the next person debugging learns it.
