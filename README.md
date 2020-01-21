# Threaded Conversation

This library adds threaded conversation with non-player characters (NPCs) to
[Dialog](https://linusakesson.net/dialog/index.php).

It is deeply indebted to
[Threaded Conversation for Inform 7](https://github.com/i7/extensions/tree/master/Chris%20Conley)
by Emily Short, Chris Conley, and many more.

This implementation borrows terminology and ideas from the original work, but is not a direct translation.

# Distribution

Currently, just get a copy of `lib/threaded-conversation.dg` and add it to your workspace and
ensure it is loaded when building or debugging.

# Status

Early days yet, but showing some progress.

Basic conversations are working reasonably well, but queued quips are quite limited and only barely
implemented.

# Using Threaded Conversation

Threaded conversation (TC) consists of a string of interactions between the player and non-player characters (NPC);
The player makes a comment, the NPC provides a reply.

In TC, each such unit of conversation is called a _quip_.

Here's an example of TC in action:

```
It is a long and riotous evening, full of unlikely stories and tall tales. But
now, most of the patrons have gone away to their rooms to sleep, or have passed
out before the fire. Even the two black bitch pups are curled on the hearth-
stone, snuffling through tiny wet noses, and pawing the air in sleep. Now is
the time to find out whether the rumors that brought you to this neighborhood
are true.

The Inn
The light is low and red. Above the fireplace hangs a map of this part of the
Empire, and on the adjacent wall is the crimson and silver banner of Richard
the Rose. The barmaid works her way from table to table, clearing away dishes
and mugs.

> ask barmaid about rumors
You say hello to the Bar Maid.

"Where I come from, over the black hills there, they say that men this side of the mountain
live as old as Methuselah," you remark. "They say the secret of eternal life is here."

"Oh, do they?" she says, sweeping crumbs of cheese and crusty bread into her hand. "The
oldest codger around these parts is old Garrick, and I would't put him beyond his four-score
and ten."

You could ask where Garrick lives, ask where the barmaid comes from, or ask whether she's
heard the stories.

> ask garrick
"Where does this old Garrick live?" you ask, trying not to seem too eager.

"Down at the pig farm," she says. "The turn off is just before you come to the river, on the
main road west. You can find it by the smell."

You could ask where the barmaid comes from or ask whether she's heard the stories.

> stories
"Have you heard any stories of long-living men?" you press her.

She purses her lips and scrubs at a circle-shaped stain on the table before her. "If you're a
fool come looking for a spring of life or a vein of immortal gold buried in the black hills,
you'd do better to go back home where you come from."

You could ask where the barmaid comes from.

>
```

You can see that threaded conversation starts by engaging an NPC in converation.
During a conversation, TC suggests likely quips, which are actually a subset of available quips.

You can see in the transcript that it's possible to `ASK BARMAID ABOUT RUMORS`, which engages the barmaid in conversation.
They player makes the comment ("Where I come from ...") and the barmaid NPC responds ("Oh, do they? ...").

The style of TC is that the player's command is a bit general, but the comment and reply in the quip is more specific.

In any case, it is possible to skip the `ASK` or `TELL` and just identify key words of the quip.

The transcript also shows how the conversation evolves, with each quip introducing new lines of discussion.
The goal with TC is encourage the player to explore the conversation tree, while giving the NPCs an air of agency
in how they respond.

Quips come in four varieties, defined by traits:

* `(questioning quip $)` - the player asks the NPC a question  ("does Lily look well?")
* `(informative quip $)` - the player tells the NPC something ("I suspect the butler did it")
* `(demonstrative quip $)` - the player performs some bit of behavior ("curse the fates")
* NPC-directed quips have no trait; these can be queued up and are output when the NPC has no immediate response

Quips are usually limited to a particular NPC; the `($Quip supplies $NPC)` establishes which NPC, or NPCs, are
associated with a quip.  Otherwise (and this is rare), the quip is available to any NPC.

The part that makes threaded conversation truly _threaded_, is that most quips aren't available at
the start of the conversation; they are structured to follow after some prior quip.

`($Quip follows $PrecedingQuip)` establishes that the quip is only valid after the preceding quip has played out.
This may be the next exchange, or some time in the future.

`($Quip directly follows $PrecedingQuip)` is more specific; the quip is only allowed immediately after
the preceding quip; it's an aside that only makes sense before the conversation continues on.

Generally, the player is free to choose new quips at any time; the `(restrictive $)` trait prevents the player
from jumping out of the thread of conversation; they must respond with qupt that _directly follows_ the current quip.

> More documentation to come ...

# License

(c) 2019-present Howard M. Lewis Ship

Licensed under the terms of the Apache Sofware Licence 2.0.

Pull Requests are encouraged; by submitting a pull request, you are irrevocably assigning copyright for any submitted
materials to the repository owner, Howard Lewis Ship.
