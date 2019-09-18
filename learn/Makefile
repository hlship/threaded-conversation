default: play

image:
	docker build -t dialog:latest .

OUT = out
DIALOG_VER = 0h02_0_30
DIALOG_ROOT = lib/dialog-$(DIALOG_VER)
MAIN = inform/3-1.dg
STORY = $(OUT)/$(patsubst %.dg,%.z8,$(notdir $(MAIN)))

$(STORY): $(MAIN) common.dg $(DIALOG_ROOT)/stddebug.dg $(DIALOG_ROOT)/stdlib.dg
	mkdir -p $(dir $(STORY))
	docker run --rm -v `pwd`:/work dialog:latest \
		$(DIALOG_ROOT)/prebuilt/linux-x86_64/dialogc -t z8 -v -o $@ $^

build: $(STORY)

# Install frotz via `brew install frotz`
play: $(STORY)
	frotz $(STORY)

clean:
	- rm -rf $(OUT)

