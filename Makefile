default: play

# Install tools via `brew install vickio/dialog/dialog-if`
# Creates files in /usr/local/share/dialog-if/

LIB=/usr/local/share/dialog-if
OUT = out
MAIN = inform/3-1.dg
STORY = $(OUT)/$(patsubst %.dg,%.z8,$(notdir $(MAIN)))

$(STORY): $(MAIN) src/common.dg $(LIB)/stddebug.dg  $(LIB)/stdlib.dg
	mkdir -p $(dir $(STORY))
	dialogc -t z8 -v -o $@ $^

build: $(STORY)

# Install frotz via `brew install frotz`
play: $(STORY)
	frotz -w 120 $(STORY)

clean:
	- rm -rf $(OUT)

