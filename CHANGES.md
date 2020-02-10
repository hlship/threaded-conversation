0.2 -- UNRELEASED

Renamed the file to `tc.dg`.

Added predicate `(action verb $Quip)`; the defaults are `ask`, `say`, and nothing (for performative quips).
For instance, sometimes the suggestion works better when the verb for an informative quip
is `tell` instead.

Added `(queue $Quip)` as a shorthand for queuing a quip for the current conversation partner.

0.1 -- 28 Jan 2020

A pre-release; still not ready for prime time.

Basic quips work, but queued NPC quips barely work, and a lot
of the logic related to suggesting in-thread vs. out-of-thread
quips is missing.

