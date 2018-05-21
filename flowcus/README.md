#  flowcus

[link for the icon on the top bar](https://www.raywenderlich.com/165853/menus-popovers-menu-bar-apps-macos)

## Core Animation on CALayer

[Core animation article ](http://www.knowstack.com/swift-mac-os-animation-part-1/)


## Send parameters with selector
the case of the menu

## looping on menu items

  for (index, _) in items.enumerated() {
  item.tag = i

 }

## Problem with submenu not being enabled

https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/MenuList/Articles/EnablingMenuItems.html

explained theres

## Close all the windows feature
https://stackoverflow.com/questions/3087193/how-to-access-windows-hierarchy-for-my-application-on-mac

## Adding a volume control 
https://stackoverflow.com/questions/7793549/control-nsslider-with-arrows-on-nsmenu-for-a-nsstatusitem-objective-c-cocoa


## System Notification, for Screen resolution change
NSApplicationDidChangeScreenParametersNotification

## to show percentage 
https://stackoverflow.com/questions/15050036/cabasicanimation-current-elapsed-time

## detect full scren and place the bar on top of the top

## add a dimmer 
https://hazeover.com/

## Updating the menu with run loop mode
https://stackoverflow.com/questions/6301338/update-nsmenuitem-while-the-host-menu-is-shown

## Format time string
https://stackoverflow.com/questions/26794703/swift-integer-conversion-to-hours-minutes-seconds

## Order a dictionary 
https://stackoverflow.com/questions/29601394/swift-stored-values-order-is-completely-changed-in-dictionary
```
You can't sort a dictionary but you can sort its keys and loop through them as follow:

let myDictionary = ["name1" : "Loy", "name2" : "Roy", "name3" : "Tim", "name4" : "Steve"]   // ["name1": "Loy", "name2": "Roy", "name3": "Tim", "name4": "Steve"]


let sorted = myDictionary.sorted {$0.key < $1.key}  // or {$0.value < $1.value} to sort using the dictionary values
print(sorted) // "[(key: "name1", value: "Loy"), (key: "name2", value: "Roy"), (key: "name3", value: "Tim"), (key: "name4", value: "Steve")]\n"
for element in sorted {
print("Key = \(element.key) Value = \(element.value)" )
}
```

## User defaults
https://developer.apple.com/documentation/foundation/userdefaults

## Build for older SDKs
https://github.com/phracker/MacOSX-SDKs
https://medium.com/@hacknicity/working-with-multiple-versions-of-xcode-e331c01aa6bc
https://stackoverflow.com/questions/11424920/how-to-point-xcode-to-an-old-sdk-so-it-can-be-used-as-a-base-sdk/11424966

xz -d name_of_the+file

## Handle multiple OS targets

The last version I'm supporting is 10.13
XCode 9.3 works well for targeting SDK 10.13 and Swift 4.1
XCode 9.2 ... 
To know the version then we need to >> https://en.wikipedia.org/wiki/Xcode

## Sing with Apple ID Developer to distrubute the app without Apple Store


## What makes the app have an icon on the dock,
Is to configure Application is Agent UI to true / false


## What resolution must the icons have
https://developer.apple.com/macos/human-interface-guidelines/icons-and-images/image-size-and-resolution/
## Dock menus
https://developer.apple.com/macos/human-interface-guidelines/menus/dock-menus/
https://developer.apple.com/macos/human-interface-guidelines/extensions/menu-bar-extras

## Markdown editors
https://github.com/alfonsodev/markr
https://github.com/iwasrobbed/Down (http://commonmark.org/)
https://github.com/ruddfawcett/Notepad

## Maos sierra
https://sketchrepo.com/free-sketch/macos-sierra-ui-kit-for-sketch-freebie/

## Touch bar support
https://sketch.cloud/s/VEp78

## Buggy apps
https://worthdoingbadly.com/appkitcompat/
https://news.ycombinator.com/item?id=17116106


## Quart Display services
https://developer.apple.com/library/content/documentation/GraphicsImaging/Conceptual/QuartzDisplayServicesConceptual/Articles/Notification.html#//apple_ref/doc/uid/TP40004235-SW1

- The kCGDisplayBeginConfigurationFlag flag is always set
> Cocoa already uses this notification mechanism to respond to display reconfigurations. As a result, when a user or application changes a display mode, turns on mirroring, or disconnects a display, Cocoa applications don’t need to be concerned with repositioning or resizing their windows. The application frameworks handle this task automatically.

If you want to receive notifications of configuration changes, here is a brief description of the steps:


https://github.com/mgrdcm/macos-fullscreenmode-test
## Detect full screen

## Open app at login by default.
## Anatomy of menu
https://developer.apple.com/macos/human-interface-guidelines/menus/menu-anatomy/

## Read & Write fileLabels 
- [About file label colors](https://developer.apple.com/documentation/appkit/nsworkspace/1527553-filelabelcolors)
- [Read all the system tags](https://stackoverflow.com/questions/19970998/get-all-filesystem-tags/19971154#19971154)
  - `~/Library/SyncedPreferences/com.apple.finder.plist`  
  > the file does not exit by default but it's created by adding a new tag.
- [More complete answer)(https://stackoverflow.com/questions/41779969/how-do-i-retrieve-all-available-finder-tags/41780350#41780350)
- [Question 1](https://stackoverflow.com/questions/38633600/read-write-file-tag-in-cocoa-app-os-x-with-swift-or-obj-c)

- [Openmeta](https://code.google.com/archive/p/openmeta/)

