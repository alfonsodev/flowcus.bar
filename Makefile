select:
	sudo xcode-select -s /Applications/Xcode.9.2.app/Contents/Developer
	xcode-select -p /Applications/Xcode.9.2.app/Contents/Developer
build:
	sudo xcode-select -s /Applications/Xcode.9.2.app/Contents/Developer
	/usr/bin/xcodebuild -target flowcus -sdk macosx10.12 -configuration Release
.PHONY: build select
