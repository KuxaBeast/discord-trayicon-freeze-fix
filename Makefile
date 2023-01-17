.PHONY: all install uninstall clean

VERSION ?= 0.0.23
DISCORD_PATH ?= $(HOME)/.config/discord/$(VERSION)

target_dir = $(DISCORD_PATH)/modules/discord_desktop_core

all: core_patched.asar

core/: $(target_dir)/core.asar system_tray.diff
	asar extract $(target_dir)/core.asar core/
	patch -d core/ -p1 < system_tray.diff

core_patched.asar: core/
	asar pack core/ core_patched.asar

install: core_patched.asar
	install -m644 core_patched.asar $(target_dir)/
	sed -i 's|\./core\.asar|\./core_patched\.asar|g' $(target_dir)/index.js

uninstall:
	rm -r $(target_dir)/core_patched.asar
	sed -i 's|\./core_patched\.asar|\./core\.asar|g' $(target_dir)/index.js

clean:
	-rm -r core/ core_patched.asar
