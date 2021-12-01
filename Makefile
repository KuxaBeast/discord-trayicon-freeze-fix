.PHONY: all install clean

version = 0.0.16
discord_path = $(HOME)/.config/discord/$(version)

target_dir = $(discord_path)/modules/discord_desktop_core

all: core_patched.asar

core/: $(target_dir)/core.asar system_tray.diff
	asar extract $(target_dir)/core.asar core/
	patch -d core/ -p1 < system_tray.diff

core_patched.asar: core/
	asar pack core/ core_patched.asar

install: core_patched.asar
#	mv -n $(target_dir)/core.asar $(target_dir)/core.asar.orig
	install -m644 core_patched.asar $(target_dir)/
	sed -i 's|\./core\.asar|\./core_patched\.asar|g' $(target_dir)/index.js

clean:
	-rm -r core/ core_patched.asar