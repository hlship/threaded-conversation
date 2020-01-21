-queueing

- immediate obligatory
    - must be said once
    - answers to players questions
- postponed obligatory
    - must happen eventually
    - survives change of subject
- postponed optional
    - defferable, casual
    - cleared on change of subject
- immediate optional
    - casual info
    - discarded if *any* comment intervenes
    

 quippishly relevant
 - part of same thread

shallowly buried
- does not indirectly follow any other quip
- considered to start a new thread "change of subject"

current quip
- Setting action variables for an actor discussing rule sets all three

dead ended
- No quip continues from the current quip
- After comment of current quip, if dead ended, then see if there's another queued quip

previous quip

grandparent quip
- used to track where player entered a thread, if re-entering other than at thread's natural beginning
- set by "rule for subject changing"


 implicit greeting
 - perhaps needs to be done as a 'rewrite' rule
 - or not ... our code evaluates quips in terms of what's available to the
   potential new conversation partner


Suprisingly hard to get error output for unrecognized quip

```
> ask barmaid about fizzbin
(I only understood you as far as wanting to ask someone something.)
```

But want it to say: `That not a current topic of conversation.`



```
> sell
You try a joke: "Planning on selling this to the highest bidder? Might be your best shot out of the game."

Begrudgingly, it's time to hand him the package and hope for the best.

Malory is taken aback. "if that's an attempt at humor, now is not the time or place. We'll be having words about this back at the den."

Perhaps this was not the best gambit. Malory has friends among the Oxford crowd, so the consequences of this unseamly exchange could be quite dire.
```

The `(on every tick)` rules are hard to schedule; the `Begrudingly` output should be towards the end, though this might be better accomplished with queued quips in any case.
