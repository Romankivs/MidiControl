#!/bin/sh

rm "MidiControl-Installer.dmg"

create-dmg \
	--volname "MidiControl Installer" \
	--volicon "volume_icon.icns" \
	--background "background.png" \
	--window-pos 200 120 \
	--window-size 650 400 \
	--icon-size 100 \
	--icon "MidiControl.app" 150 175 \
	--hide-extension "MidiControl.app" \
	--app-drop-link 535 175 \
	"MidiControl-Installer.dmg" \
	"../DerivedData/MidiControl/Build/Products/Release/MidiControl.app"
