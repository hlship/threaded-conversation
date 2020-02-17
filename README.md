# Threaded Conversation

This library adds threaded conversation with non-player characters (NPCs) to
[Dialog](https://linusakesson.net/dialog/index.php).

It is deeply indebted to
[Threaded Conversation for Inform 7](https://github.com/i7/extensions/tree/master/Chris%20Conley)
by Emily Short, Chris Conley, and many more.

This implementation borrows terminology and ideas from the original work, but is not a direct translation.

# Distribution

Currently, just get a copy of `lib/tc.dg` and add it to your workspace and
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
During a conversation, TC suggests likely quips, which are a subset of available quips. 
Likely quips are those that follow the current thread of conversation.

You can see in the transcript that it's possible to `ask barmaid about rumors`, which engages the barmaid in conversation.
The player makes the comment ("Where I come from ...") and the barmaid NPC replies ("Oh, do they? ...").
The comment and reply is called "discussing", and are implemented by the Dialog actions `[discuss $Quip]` and `[discuss $Quip with $NPC]`.

The style of TC is that the player's command is a bit general, but the comment and reply in the quip is more specific.

In any case, it is possible to skip the `ask` or `tell` and just identify key words of the quip.

The transcript also shows how the conversation evolves, with each quip introducing new lines of discussion.
The goal with TC is encourage the player to explore the conversation tree, while giving the NPCs an air of agency
in how they respond.

## Quip Varieties

Quips come in four varieties, defined by traits:

* `(questioning quip $)` - the player asks the NPC a question  ("does Lily look well?")
* `(informative quip $)` - the player tells the NPC something ("I suspect the butler did it")
* `(demonstrative quip $)` - the player performs some bit of behavior ("curse the fates")
* NPC-directed quips have no trait; these can be queued up and are output when the NPC has no immediate response

Quips are usually limited to a particular NPC; `($Quip supplies $NPC)` establishes which NPC, or NPCs, are
associated with a quip.  Otherwise (and this is rare), the quip is available to any NPC.

The part that makes threaded conversation truly _threaded_, is that most quips aren't available at
the start of the conversation; they are structured to follow after some prior quip.

## Quip Ordering

`($Quip follows $PrecedingQuip)` establishes that the quip is only valid after the preceding quip has been discussed.
There isn't really a concept of time, the NPC is happy to pick up the
conversation thread as the next action, or at any time in the future.

`($Quip directly follows $PrecedingQuip)` is more specific; the quip is only allowed immediately after
the preceding quip; it's an aside that only makes sense before the conversation continues on.
If some other quip is discussed, the quip will no longer be available for discussion.

By way of illustration, here's first couple of quips in the above exchange:

```
#barmaid
(female *)
(name *) Bar Maid
(descr *) A pretty, if bored-looking, wench.
(dict *) woman barmaid

#whether-rumors-tell-truly
(questioning quip *)
(* supplies #barmaid)
(name *) whether the rumors tell truly
(dict *) rumor
(comment *)
    "Where I come from, over the black hills there,
    they say that men this side of the mountain
    live as old as Methuselah," you remark. "They
    say the secret of eternal life is here."
(reply *)
    "Oh, do they?" she says, sweeping crumbs of cheese
    and crusty bread into her hand.
    "The oldest codger around these parts is old
    Garrick, and I would't put him beyond his four-score
    and ten."

#garrick
(animate *)
(name *) old Garrick
(dict *) codger

#where-garrick-lives
(questioning quip *)
(name *) where Garrick lives
(* mentions #garrick)
(comment *)
    "Where does this old Garrick live?" you ask, trying not to seem too eager.
(reply *)
    "Down at the pig farm," she says. "The turn off is just before you come to the river, on the main road west.
    You can find it by the smell."
(* supplies #barmaid)
(* follows #whether-rumors-tell-truly)
```

Like most Dialog objects, quips supply `(name $)` and `(dict $)`; the name is used when TC suggests quips, or during
any kind of disambiguation.
Quip names are always proper.

## Mentioning

Also, note `(* mentions #garrick)`; a quip may _mention_ an object.
Such objects are presumed known to any NPC.
So the second interaction could have been `ask codger` (or even just `codger` or `old`) and TC would have identified
object #garrick, and from there, the #where-garrick-lives quip, by the mentioning relationship.

Mentioning may also be used with Dialog topics.

## Conversation Partner

The global variable `(conversation partner $)` stores the NPC the player is currently conversing with.

## Suggestions

On every turn during a conversation, the player is presented with a list of quips that can be discussed.
This excludes unlikely quips -- by default, a quip is unlikely if it changes the thread of conversation away from
the current quip.

In addition, dubious quips (see below) and quips that the player recollects are never suggested.

## Recollection

When a quip executes, the player and the NPC are updated to recollect the quip.

The `($NPC recollects $Quip)` predicate succeeds if the specific NPC was the conversation partner when the quip
was discussed.

## Immediate

In some cases, the phrasing of a comment or reply might vary based on whether the quip is executed immediately
after its predecessor, or after returning to that line of conversation from some detour.
The `(immediately)` predicate will succeed when the quip is immediately chosen, rather than later.

```
#where-she-came-from
(questioning quip *)
(name *) where she came from
(comment *)
    "And where did you come from?" you ask.
(reply *)
    "From the grey castle beyond those mountains" she replies.

#how-to-find-castle
(questioning quip *
(name *) how to find the castle
(* follows #where-she-came-from)
(comment *)
    (immediately)
    How can I find it?
(comment *)
    And how might I locate your castle?
```

## Controling availability

The `(off limits $)` predicate can remove a quip from availability.
This might be useful if a particular line of conversation makes sense only if other conditions have been met:
an object must be present, a fact must be known, or so forth.

```
#what-watermelon-is-for
(questioning quip *)
(name *) what the watermelon is for
(* mentions #watermellon)
(comment *)
    "Hey," you ask, "what's that watermelon for?"
(reply *)
    "I'll tell you later", he replies.  But he never does.
(off limits *)
    ~(player can see #watermelon)
```

## Dubious Quips

A quip may be dubious; such quips are not suggested normally.

```
#hannigan-eats-people
(questioning quip *)
(name *) whether Mr. Hannigan eats people
(dubious *)
    ~(player can see #gnawed-shin-bone)
```

Dubious quips are never suggested to the player, but are still valid if the player stumbles upon them.  Here, we can accuse Hannigan of cannibalism at any time, but it won't be suggested to the player until some evidence is at hand.

## Nag

A quip may optionally include a nag, via the`(nag $)` predicate.
On a turn in which the player is in a conversation but fails to discuss a quip with the NPC, then the
nag is used to remind the player to respond.

Generally, the nag should start with a query to `(beat $)` to break up the 
stream of output.

> This feature is likely insufficiently implemented.

## The Beat

When an NPC has queued quips, a beat is used to break up the reply to the player's comment, from the 
comment of the queued quip.
By default, a beat simply outputs `A moment passes.` and a paragraph break.

Providing a beat is a good chance to inject some character into the conversation.

# Restrictive Quips

Generally, the player is free to choose new quips at any time; however, at certain points in a 
conversation, the player must respond.

The `(restrictive $)` trait prevents the player
from jumping out of the thread of conversation; they must respond with quip that _directly follows_ the current quip.

```
#request-help
%% NPC directed quips need no trait or even a name
(restrictive *)
(reply *)
    "Wilt thou accept this quest, hero?"
(nag *)
    "Though must!"

#quest-yes
(informative quip *)
(name *) yes to the quest
(* directly follows #request-help/#quest-no)
(comment *)
    "Yes."
(reply *)
    "Truly, thou art brave!".

#quest-no
(informative quip *)
(name *) no to the quest
(* directly follows */#request-help)
(comment *)
    "No."
(reply *)
    "But thou must!"
(nag *)
    "Thou must!"
```


## Library Links

When the Dialog predicate `(library links enabled)` succeeds, then the `(describe action $)` predicates
involving quips will output links, not just text. 
The link will discuss the identified quip.

## Queueing quips (NPC driven)

Not really implemented yet.  Details forthcoming.

> More documentation to come ...

# License

(c) 2019-present Howard M. Lewis Ship

Licensed under the terms of the Apache Sofware Licence 2.0.

Pull Requests are encouraged; by submitting a pull request, you are irrevocably assigning copyright for any submitted
materials to the repository owner, Howard Lewis Ship.
