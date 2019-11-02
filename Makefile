default: play

# Install tools via `brew install vickio/dialog/dialog-if`
# Creates files in /usr/local/share/dialog-if/

LIB=/usr/local/share/dialog-if
OUT = out
MAIN = src/tc-test.dg
TEST_STORY = out/$(patsubst %.dg,%d.z8,$(notdir $(MAIN)))

SOURCES = $(MAIN) \
	src/common.dg \
	src/threaded-conversation.dg

TEST_SOURCES = $(SOURCES) \
	$(LIB)/stddebug.dg \
	$(LIB)/stdlib.dg

$(TEST_STORY): $(TEST_SOURCES)
	mkdir -p $(dir $@)
	dialogc -t z8 -v -o $@ $^

# Install frotz via `brew install frotz`
play: $(TEST_STORY)
	frotz -w 120 $^

clean:
	rm -rf out

repl:
	dgdebug $(TEST_SOURCES)
