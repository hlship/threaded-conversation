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
