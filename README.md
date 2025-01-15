# Dialog Libs

This repository is a collection of small libraries to extend
[Dialog](https://linusakesson.net/dialog/index.php).

- [Threaded Conversation](docs/conversation.md) - make NPCs more interactive with complex conversations
- [Scenes](docs/scenes.md)  - organize game logic
- [Tutorial Mode](docs/tutorial-mode.md) - give new players some help
- [roominfo command](docs/roominfo.md) - concise, hierarchical description of current room (for debugging)


# Distribution

Simply copy the `lib/ext` folder into your repository.  Add `lib/ext` to your :library sources, 
and `lib/ext/debug` to your :debug sources.

Note that each individual library has a `%% dependencies:` comment at the top; if you choose to use just
a subset of the libraries in this repository, reference the comment as a guide to what other libraries you must
include.

Currently, only some of the debug libraries depend on the `lib/ext/debug/annotations.dg` library.


# License

(c) 2019-present Howard M. Lewis Ship

Licensed under the terms of the Apache Software License 2.0.

Pull Requests are encouraged; by submitting a pull request, you are irrevocably assigning copyright for any submitted
materials to the repository owner, Howard Lewis Ship.
