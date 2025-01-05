# 0.8 -- UNRELEASED

- Renamed repository to 'dialog-libs' since its not just about threaded conversation anymore
- Split out debug code into several smaller libraries
- Add the scenes library
- Split up the documentation

# 0.7.1 -- 8 Jan 2021

- Added `interface` rules to prevent warnings about a few built-in rules
  (exposed by Dialog 0m/03).

# 0.7 -- 22 Oct 2020

- The suggestions are now triggered from `(late on every tick)`
- `convinfo` and `roominfo` commands no longer output using `(log)`
- The `[perform quip $Quip]` action is now properly described
- Remove `(avoid talking heads for $Quip)` and just use `(beat $Quip)`

# 0.6 -- 9 Oct 2020

Broke the debugging code into a companion library, `lib/hlsdebug.dg`.

Added the `convinfo` debugging command, which displays the conversation status.

Added the `roominfo` debugging command, which displays information about the current room and
the objects within -- like `@tree` but for a single room, and more detailed.

# 0.5 -- 27 Sep 2020

TC now extends and overrides the standard library ask/tell mechanics.

`(reset conversation partner)` now also clears out the variables tracking
the current conversation thread.

The traits used to identify quips have changed to `(asking quip $)`,
`(telling quip $)` and `(performing quip $)`.

Added the `(about $)` trait that modifies how actions for asking and telling
quips are formatted.

# 0.4 -- 25 Jul 2020

- Added `(after $NPC has replied with $Quip)` notification

# 0.3.2 -- 24 Jul 2020

Updated to work with Dialog 0k05.

# 0.3.1 -- 20 Apr 2020

Correct the reported `(extension version)`.

# 0.3 -- 13 Apr 2020

- Added `(reset conversation partner)` predicate to clean up the current conversation

- Dubious quips are now very unlikely, not simply unlikely

- Added `(prevent talking heads for $Quip)`

- Added the `change subject` command

- Updated for Dialog 0j/02, including `interface` declarations

- Moved around the logic for nags so that they follow the description of the non-conversational
action, and precede the "You could ..." text; this is a more natural flow

# 0.2 -- 17 Feb 2020

- Renamed the file to `tc.dg`

- Added predicate `(action verb $Quip)`; the defaults are `ask`, `say`, and nothing (for performative quips).
For instance, sometimes the suggestion works better when the verb for an informative quip
is `tell` instead

- Added `(queue $Quip)` (and several related predicates) as a shorthand for queuing a quip for the current conversation partner

- Added `(conversation status)` predicate to provide information from the debugger

- A bunch of improvements to quip queueing, tracking of changes of subject, and so forth

# 0.1 -- 28 Jan 2020

- A pre-release; still not ready for prime time.

- Basic quips work, but queued NPC quips barely work, and a lot
of the logic related to suggesting in-thread vs. out-of-thread
quips is missing

