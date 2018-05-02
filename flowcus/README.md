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
