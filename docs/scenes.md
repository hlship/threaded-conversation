# Scenes

Scenes represent special situations within the overall flow of your project's narrative. 
The `lib/hls/scenes.dg` library represents a more concrete set of code than the general pattern of 
scenes described in [the Dialog manual](https://linusakesson.net/dialog/docs/timeprogress.html#cutscenes).

Essentially, each scene is triggered by some situation in the world, runs for a bit, then completes. Most scenes
are one-offs, but other scenes can repeat.

Example ideas for scenes:

- You are a burglar; a scene starts when the home owner enters the house, and the game constrains you from
  making yourself visible or making noise; the scene ends when the home owner goes upstairs.
- Your game features combat sections; once combat begins, certain commands are not allowed, until the combat is resolved.
- Once you've gathered all the suspects and evidence in your detective game, the reveal of the
  murderer can begin

The library tracks which scenes are active at any given time, and asks inactive scenes if they should start, and 
active scenes if they are complete, on every tick.

Scenes and conversations work well together; scenes can be triggered when certain
conversation quips are recollected, or certain quips may be off limits until after
particular scenes are in progress or completed.

# Scene Traits

Scenes must have the `(scene $)` trait.

Normally, a scene will start at most once.
A scene may also have the `(recurring $)` trait to indicate that it may be started again after it completes.

# Scene Predicates

The `(start $)` predicate is invoked, every tick.  
It is invoked on any scenes that are not already in progress.
Scenes that have completed, but are recurring, are also eligible to (re-)start.

If `(start $)` succeeds, the scene will be marked as `($ has started)` and `($ in progress)`.
The start predicate should also narrate the scene's opening.

An in progress scene is also checked every tick; the `(complete $)` rule is invoked for each in progress scene.
If a scene completes, it will be marked as `($ has completed)` and `~($ in progress)`.  Like start, the complete
predicate will output text discussing how the scene ends, if it succeeds.

In addition, there is an `(on every tick during $)` predicate that is invoked for each in progress scene.

The order is:
* identify any completed scenes
* notify all in progress scenes
* identify any started scenes

# Scene Properties

- `($ has started)` succeeds if the scene has been started at least one
- `($ in progress)` succeeds if the scene is currently in progress
- `($ has completed)` succeeds if the scene has ever completed

# Example

```
Just wait here, we won't be but a minute.

Empty Office
You've been left in this office to stew a bit before they are ready for your
interview. To say it is bare-bones is an understatement. No windows, or even any
furniture beyond a single battered table.

> x table
A dented and dusty metal table. Someone has left a shiny penny on the table.
Oddly, the only decoration in the room is a metronome sitting in one corner of
the table.

> take penny
You take the shiny penny off the table.

> drop it
The shiny penny falls to the ground.

As the penny hits the floor, you hear a click and a low humming starts. A thin
red line of illumination appears around the edges of the floor.

> x metronome
A small box with a kind of inverted pendulum standing up. If it were pushed, it
would start swinging back and forth at an even rate.

> push it
You give the metronome a bit of a push. As expected, the metronome's pendulum
starts to swing back and forth.

> l
Empty Office
You've been left in this office to stew a bit before they are ready for your
interview. To say it is bare-bones is an understatement. No windows, or even any
furniture beyond a single battered table. The edges of the floor are lit with a
dim red light, and you can hear a low hum.

You see a shiny penny here.

The metronome's pendulum swings to one extreme and there's an audible click.

> take penny
You take the shiny penny.

As you pick up the penny, there's another click, and the red illumination
disappears.

The metronome's pendulum swings to one extreme and there's an audible click.

> l
Empty Office
You've been left in this office to stew a bit before they are ready for your
interview. To say it is bare-bones is an understatement. No windows, or even any
furniture beyond a single battered table.

The metronome's pendulum swings to one extreme and there's an audible click.

>
```

There's two scenes here: one for the extra effects when the penny is on the floor, and 
another for after the metronome has been pushed.


```
#office
(room *)
(name *) Empty Office
(#player/#table is #in #office)
(look *)
    You've been left in this office to stew a bit before they are ready for your interview.
    To say it is bare-bones is an understatement. No windows, or even any furniture beyond a 
    single battered table.
    (if) (#penny-dropped in progress)
    (then)
        The edges of the floor are lit with a dim red light, and you can hear a low hum.
    (endif)

#penny-dropped
(scene *)
(recurring *)
(start *) 
    (#penny is #in #office)
    (par)
    As the penny hits the floor, you hear a click and a low humming starts.
    A thin red line of illumination appears around the edges of the floor.
(complete *)
    ~(#penny is #in #office)
    (par)
    As you pick up the penny, there's another click, and the red illumination disappears.
```

The triggering rule for this scene is quite simple, and you could imagine scattering the same
check in several places, to adjust the room description.  In a real project, the rules for starting
a scene may be much more complicated, so the query `($ in progress)` is both more accurate and more concise.

In fact, you might have scenes that only start when other scenes are completed, `($ has completed)` or even in progress `($ in progress)`.


By design, there isn't a way to directly start a scene: you must provide necessary preconditions that
can be checked inside `(start $)`.  However, those can be as simple as a property of an object:

```
#metronome
(item *)
(name *) metronome
(dict *) metro
(descr *)
    A small box with a kind of inverted pendulum standing up.  If it were pushed, it would
    start swinging back and forth at an even rate.
(after [push *])
    (now) (* is active)

#the-beat
(scene *)
(start *)
    (#metronome is active)
    As expected, the metronome's pendulum starts to swing back and forth.
(on every tick during *)
    (par)
    The metronome's pendulum swings to one extreme and there's an audible click.
```

# Debugging Scenes

The `lib/hls/debug/sceneinfo.dg` library contains three debugging commands.

The `sceneinfo` command outputs the state of all scenes:

```
> sceneinfo
#penny-dropped (recurring, has started, has completed)
#the-beat (has started, in progress)

>
```

In addition, the `debug scenes` command will enable scene debugging.
When scene debugging is enabled, a `(log)` will be made of each scene that completes,
in progress, or started.

```
Just wait here, we won't be but a minute.

Empty Office
You've been left in this office to stew a bit before they are ready for your
interview. To say it is bare-bones is an understatement. No windows, or even any
furniture beyond a single battered table.

> debug scenes
Scene debugging enabled.

> take penny
You take the shiny penny off the table.

> drop it
The shiny penny falls to the ground.

As the penny hits the floor, you hear a click and a low humming starts. A thin
red line of illumination appears around the edges of the floor.
scene #penny-dropped started

> push metronome
You give the metronome a bit of a push.
scene #penny-dropped in progress
As expected, the metronome's pendulum starts to swing back and forth.
scene #the-beat started

> z
A moment slips away.
scene #penny-dropped in progress
scene #the-beat in progress

The metronome's pendulum swings to one extreme and there's an audible click.

> take penny
You take the shiny penny.

As you pick up the penny, there's another click, and the red illumination
disappears.
scene #penny-dropped completed
scene #the-beat in progress

The metronome's pendulum swings to one extreme and there's an audible click.

> 
```

The `debug scenes off` command turns scene debugging back off.

