0.3 -- UNRELEASED

Added`(reset conversation partner)` predicate to clean up the current conversation.

Dubious quips are now very unlikely, not simply unlikely.

Added `(prevent talking heads for $Quip)`.

0.2 -- 17 Feb 2020

Renamed the file to `tc.dg`.

Added predicate `(action verb $Quip)`; the defaults are `ask`, `say`, and nothing (for performative quips).
For instance, sometimes the suggestion works better when the verb for an informative quip
is `tell` instead.

Added `(queue $Quip)` (and several related predicates) as a shorthand for queuing a quip for the current conversation partner.

Added `(conversation status)` predicate to provide information from the debugger.

A bunch of improvements to quip queueing, tracking of changes of subject, and so forth.

0.1 -- 28 Jan 2020

A pre-release; still not ready for prime time.

Basic quips work, but queued NPC quips barely work, and a lot
of the logic related to suggesting in-thread vs. out-of-thread
quips is missing.

