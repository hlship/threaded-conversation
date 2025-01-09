# Tutorial Mode

A common complaint about interactive fiction, for people who didn't grow up with Zork
(or Curses), is that new players don't even know where to begin.

Tutorial mode (inspired by an Inform 7 extension) watches over the player and gives them
ideas about what they can do.  Tutorial mode automatically adapts to the world of the
game it is included in.

Tutorial mode is available in the library `lib/hls/tutorial-mode.dg`.
A second file, `lib/hls/tutorial-mode-standard-actions.dg` provides suggestions
for many of Dialog's built in actions.

TODO: EXAMPLE HERE

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

## Suggestions

Tutorial mode consists of number of objects, _suggestions_, that each identify
something the player can do, make a suggestion to the player, recognize when the player
has performed the suggested action, and perhaps comment after the player performs the
suggestion.
 
The core trait is `(tutorial suggestion $)`.

A suggestion must provide a rule for `(can perform $Suggestion with $Operand)`.
This rule identifies if the suggestion can be provided and, if so, with what object or other data.
For example, the built-in #examine suggestion looks for an interesting object "nearby", not 
carried by the player, and also visible to the player.  That object gets bound to $Operand.

The `(suggest $Suggestion with $Operand)` rule actually produces the print.

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
    ~($Object is hidden)
(suggest * with $Item)
    Often, there will be interesting objects nearby; you can get more information
    about them by examining them;
    try (suggest command [examine $Item])
    \(or just (suggest command [x $Item]) \).
(* is performed by [examine])
```

Here, the `(can perform $ with $)` rule does a search for a specific kind of object, which gets passed back
to the `(suggest $ with $)` rule.

Occasionally, you may want to add some additional explanation _after_ the player performs the suggestion.
The `(narrate after suggestion $)` predicate provides this opportunity.

```
#enter 
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
(narrate after suggestion *)
    If you can (suggest command [enter]) something, you can probably (suggest command [leave]) as well.
```

The `(ignored by tutorial $)` trait can be used to have suggestions ignore certain objects (this is the responsibility
of the suggestions `(can perform $ with $)` rule). All hidden objects `($ is hidden)` are ignored by tutorial.
You may have cases where particular objects are not ideal as examples in a tutorial and can be made ignored explicitly.

Note how `($ is performed by $)` doesn't care what you specifically did enter, just the fact that you've successfully
performed the command.  After doing so, you get the suggestion for how to leave.  Often `(narrate after suggestion $)`
is easier than creating an entirely new suggestion.

`(narrate after suggestion $)` will only be invoked if tutorial mode printed the suggestion; as some point; if the player 
managed to enter something before the #enter suggestion was suggested, then the after narration is skipped.

When this narration does occur, then no new suggestion will be made that tick; this ensures you only get at
most one block of tutorial per command.

## Customizations

The `(suggest command $)` rule can be passed objects in the action list; 
it doesn't just print out the `(name $)` of the object,
as that can be awkward ... you want the print command to be *open can* not *open rusty tin can* (for example).

The normal logic is to get the `(name $)` of the object, and use just the last word.

That's not always what you want; you can override `(command word $)` for an object to print the word
(or words) that represent that object in a command:

```
#rusty-can
(command word *) can
```

## Properties

Once tutorial mode has printed a suggestion, it will set `($ has been suggested)`.
When it recognizes that the player has performed a suggestion (even if not suggested), it
will set `($ has been performed)`.  

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

The library `lib/hls/debug/tutorial-mode-debug.dg` adds a `tutorialinfo` command.

TODO: Example



