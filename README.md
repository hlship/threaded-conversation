# Threaded Conversation (& More!)

This library adds threaded conversation with non-player characters (NPCs) to
[Dialog](https://linusakesson.net/dialog/index.php).

Conversations are designed to flow naturally, giving NPCs (the illusion of) understanding
the conversation and having agency. Command parsing is more sophisticated than the 
Dialog standard library's ask/tell system.

An example exchange:

```
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

This library is deeply indebted to
[Threaded Conversation for Inform 7](https://github.com/i7/extensions/tree/10.1/Chris%20Conley)
by Emily Short, Chris Conley, and many more.

This implementation borrows terminology and ideas from the original work, but is not a direct translation.

Out of convenience, this repository also hosts some additional code (such as the `roominfo` debugging command) that is
not specifically tied to threaded conversations.  Treat this as a buffet ... consume just what you need.

# Dialog Version

TC has been tracking along with each new release of Dialog; it is currently tested against `0m/01`, the latest release.

# Distribution

Simply copy the `lib/tc` folder into your repository.  Add `lib/tc/*.dg` to your :library sources, 
and `lib/tc/debug/*.dg` to your :debug sources.

# Documentation

- [Threaded Conversation](docs/conversation.md)
- [Scenes](docs/scenes.md)


# TODO

- Startup checks similar to Inform7 (prevent unexpected loops, etc.)
- Optimizations (that may only be needed in full size games)
- Tune the logic for in-thread vs. out-of-thread
- Multi-way conversation (e.g., other present NPCs may have queued quips)
- `(queue $Quip last for $NPC as $Precedence)`

# License

(c) 2019-present Howard M. Lewis Ship

Licensed under the terms of the Apache Software License 2.0.

Pull Requests are encouraged; by submitting a pull request, you are irrevocably assigning copyright for any submitted
materials to the repository owner, Howard Lewis Ship.
