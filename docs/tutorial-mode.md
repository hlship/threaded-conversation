# Tutorial Mode

A common complaint about interactive fiction, for people who didn't grow up with Zork
(or Curses), is that new players don't even know where to begin.

Tutorial mode (inspired by an Inform 7 extension) watches over the player and gives them
ideas about what they can do.  Tutorial mode automatically adapts to the world of the
game it is included in.

Tutorial mode is available in the library `lib/ext/tutorial-mode.dg`.
A second file, `lib/ext/tutorial-mode-standard-actions.dg` provides suggestions
for many of Dialog's built in actions.

This is an example from the tutorial mode test suite, the first few moves of a game
under development:

```
Well, that was odd. Your were just... someplace? And now you're... someplace
else?

Who Goes There
An interactive fiction by Howard M. Lewis Ship.
Release 0. Serial number DEBUG.
Dialog Interactive Debugger (dgdebug) version 0m/03. Library version 0.46.
Debugging extension 1.1.
Dialog Libs 0.8 by Howard Lewis Ship

Outside The Lamp And The Egg Pub
You're on a narrow cobblestone path that threads between closely-set, squat
stone houses. It's just after sunset and, and in the dimness, you can make out a
number of doors, all closed, and a few windows, all barricaded behind sturdy
shutters.

The exception is the pub itself; through the somewhat dusty panes of the window
you can make out a hint of light and movement.

[This game has a built-in tutorial mode for players new to interactive fiction;
it suggests common commands that you can try. You can turn this off with 
tutorial off or back on with tutorial on.]

> i
You have a small key. You're wearing your grey trousers and your frilly jacket.

[Often, there will be interesting objects nearby; you can get more information
about them by examining them; try examine door (or just x door).]

> x door
The door is fashioned from heavy wood darkened by time and use, with impressive
brass fittings.

[You are present as part of this world too. Try look at me or l self to get an
idea of who you are.]

> l self
You glance down down with the odd feeling that you'll be surprised by what you
see. You are a tall, lean figure, with a shock of white hair over a clean-shaven
and somewhat long face.

[You are carrying your frilly jacket; you can leave it here with drop jacket.]

>
```

The text is brackets are the tutorial suggestions; during play, the suggested commands are
in bold font.

## Enabling Tutorial Mode

Tutorial mode is off by default; the best way to enable it is to add `(enable tutorial mode)`
to the end of your project's `(into)` rule. 

```
(intro)
    (banner)
    (try [look])
    (enable tutorial mode)
```

`(enable tutorial mode)` will print an initial tutorial suggestion that explains
that tutorial mode exists, and how to disable it.

The global `(tutorial mode enabled)` controls whether tutorial mode will print suggestions.

Tutorial mode adds commands `tutorial on` and `tutorial off`.

## Suggestion Objects

Tutorial mode centers around suggestion objects;  each will identify
something the player can do, facilitate printing  a suggestion to the player, 
recognize when the player has performed the suggested action, 
and perhaps comment after the player performs the suggestion.
 
The core trait is `(tutorial suggestion $)`.

A suggestion must provide a rule for `(can perform $Suggestion with $Operand)`.
This rule identifies if the suggestion can be provided and, if so, with what object or other data.
For example, the built-in #examine suggestion looks for an interesting object "nearby", not 
carried by the player, and also visible to the player.  That object gets bound to $Operand.

For example, the tutorial suggestion for the inventory command:

```
#inventory
(tutorial suggestion *)
(can perform * with [])
(suggest * with $)
    Try (suggest command [inventory])
    \(or just (suggest command [i]) \) to see what you are carrying.
(* is performed by [inventory])
```

Since you can _always_ perform inventory, the $Operand is bound to an empty list (as a placeholder) and ignored.

Note the use of `(suggest command $Action)`, which takes care of formatting the command in bold.

The `($ is performed by $)` predicate allows tutorial mode to identify when the suggestion has been carried out;
this prevents tutorial mode from suggesting things the player has already demonstrated.

A more complicated example:

```
#examine
(tutorial suggestion *)
(can perform * with $Object) 
    (current player $Player)
    %% Choose an object in the current room
    (current room $Room)
    *($Object is #in $Room) 
    ~($Player = $Object)
    %% Exclude what the player carries
    ~($Object has ancestor $Player)
    *(player can see $Object)
    ~(ignored by tutorial $Object)
(suggest * with $Item)
    Often, there will be interesting objects nearby; you can get more information
    about them by examining them;
    try (suggest command [examine $Item])
    \(or just (suggest command [x $Item]) \).
(* is performed by [examine])
```

Here, the `(can perform $ with $)` rule does a search for a specific kind of object, which gets provided
to the `(suggest $ with $)` rule.

The `(ignored by tutorial $)` trait can be used to have suggestions ignore certain objects (this is the responsibility
of the suggestion's `(can perform $ with $)` rule). All hidden objects `($ is hidden)` are ignored by tutorial.
You may have cases where particular objects are not ideal as examples in a tutorial and can be made ignored explicitly.


Occasionally, you may want to add some additional explanation _after_ the player performs the suggestion.
The `(after performance suggest $)` predicate provides this opportunity.

```
#enter-something
(tutorial suggestion *)
(can perform * with $Container)
    (current room $Room)
    *($Container is #in $Room)
    (actor container $Container)
    (player can see $Container)
    ~(ignored by tutorial $Container)
(suggest * with $Container)
    Sometimes, you move around the world not by walking in any particular direction,
    but by going inside some of the things you find.  For example,
    you can (suggest command [enter $Container])
    to see what's inside (the $Container).
(* is performed by [enter $])
(after performance suggest  *)
    If you can (suggest command [enter]) something, you can probably (suggest command [leave]) as well.
```

Note how `($ is performed by $)` doesn't care what you specifically did enter, just the fact that you've successfully
performed the command.  After doing so, you get the suggestion for how to leave.  Often `(narrate after suggestion $)`
is easier and more effective than creating an entirely new suggestion.

`(narrate after suggestion $)` will only be invoked if tutorial mode printed the suggestion at some point; 
if the player managed to enter something before the #enter suggestion was suggested, then the after narration is skipped.

When this narration does occur, then no new suggestion will be made that tick; this ensures you only get at
most one block of tutorial between commands.

## Timing

Suggestions are printed from `(late on every tick)` so they are generally
the last thing output just before the input prompt.

[Threaded conversation](conversation.md) also operates `(late on every tick)` but will make suggestions about conversation topics _before_ tutorial mode prints
its suggestions.

## Customizations

The `(suggest command $)` rule can be passed objects in the action list; 
it doesn't just print out the `(name $)` of the object,
as that can be awkward ... you want the printed command to be *open can* not *open tin can covered in rust* (for example).

The logic for printing parts of the suggested command is in the rule `(command word $)`; for objects, the default behavior
is to get the `(name $)` of the object, and use just the last word.

That's not always what you want; you can override `(command word $)` for an object to print the word
(or words) that represent that object in a command:

```
#rusty-can
(name *) tin can covered in rust 
(command word *) can
```

## Properties

Once tutorial mode has printed a suggestion, it will set `($ has been suggested)`.
When it recognizes that the player has performed a suggestion (even if tutorial mode did not get a chance to suggest it), 
then `($ has been performed)` will be set.  

It may make sense for a suggestion's `(can perform $ with $)` to include guards that check if
other suggestions have or have not been suggested or performed.

For example:

```
#drop
(tutorial suggestion *)
(can perform * with $Item)
    (#inventory has been performed)
    (current player $Player)
    *($Item is $ $Player)
(suggest * with $Item)
    You are carrying (a $Item); you can leave it here with
    (suggest command [drop $Item]).
(* is performed by [drop $])
```
The #drop suggestion will not be considered until after the player has performed an inventory.


## tutorialinfo command

The library `lib/ext/debug/tutorial-mode-debug.dg` adds a `tutorialinfo` command.

The command prints out whether tutorial mode is enabled or disabled, and the state of each suggestion.

```
 > tutorialinfo
Tutorial mode (enabled) suggestions:
#inventory (suggested, performed)
#examine (suggested)
#look-self (suggested)
#take (suggested, performed)
#drop (suggested, performed)
#wear (suggested, performed)
#leave (suggested)
#enter
```


