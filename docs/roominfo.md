## roominfo command

This `lib/hls/debug/roominfo.dg` library provides a `roominfo` 
command that prints useful information about the current room and all the objects within it.

For example, `roominfo` near the start of [Sand-dancer](https://github.com/hlship/sanddancer-dialog) yields:

```
> roominfo
#middle-of-nowhere (around the tower, in range of headlights, inherently dark)
    #tire-tracks #in
    #tower #in
    #sagebrush #in
    #desert-sand #in
    #pickup-truck #in (closed)
        #knock #in (provides light)
            #lighter #heldby
            #wallet #heldby (closed)
                #license #in
                #receipt #in
                #photo #in (closed)
                    #ultrasound #in
            #jacket #wornby
            #emotional-baggage #heldby
                #grandmas-stories #in
        #jade #in
        #glove-compartment #partof (closed)
            #pack #in
        #headlights #partof
    #whiffs-of-gasoline #in
    #saguaro #in
    #lizard #in (animate)
```

This provides a wealth of information about the current room and its contents, all in a single place.

The annotations (such as "closed" or "inherently dark") are extensible via the `(annotate $Obj with $Annotation)` predicate;
Sand-dancer adds annotations to identify the region a room is in ("around the tower"), for example.