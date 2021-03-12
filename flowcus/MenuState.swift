//
//  MenuState.swift
//  flowcus
//
//  Created by Alfonso on 03.05.18.
//  Copyright © 2018 Codefulness. All rights reserved.
//
import Cocoa
import Foundation
import AVFoundation
import CoreGraphics

//https://developer.apple.com/documentation/coregraphics/core_graphics_functions
//https://gist.github.com/suzp1984/f14cfab6871e51bee70979a40c1c9760#file-nsscreen-devicename-swift
//idea use is built in display to name the macbook display (or Imac) and the rest get name by serialNumber
var mainID = CGMainDisplayID()
struct HardwareDisplay {
    var name: String = ""
    var displayId: CGDirectDisplayID
    var serialNumber: UInt32 = 0
    var width: Int
    var hight: Int
}

func getDisplayData() -> [HardwareDisplay] {
    var result: [HardwareDisplay] = []
    let maxDisplays: UInt32 = 16
    var displayCount: UInt32 = 0
    var onlineDisplays = [CGDirectDisplayID](repeating: 0, count: Int(maxDisplays))
    let dErr = CGGetOnlineDisplayList(maxDisplays, &onlineDisplays, &displayCount)

     if dErr.rawValue > 0 {
        print("error")
        print(dErr)
    }

    // We won't find the serial number in a built in screen, like 
    // the screen of a Macbook Pro, so in that case is an exception 
    // And we nane it "Built in screen" from example.
    // For the rest of screen we can query the name by serial number
    // Note that it is possible and reasonable for a system to have no displays
    // marked as built-in. For example, a portable system running with the lid closed may report no built-in displays.

    for currentDisplayId in onlineDisplays {
        if currentDisplayId == 0 {
            continue
        }
        var name = ""
        if CGDisplayIsBuiltin(currentDisplayId) == 1 {
            name = "Built in"
        } else {
            name = getScreenNameBySerialName(CGDisplaySerialNumber(currentDisplayId)) ?? "External display"
            if CGMainDisplayID() == currentDisplayId {
                name = name + " (Primary)"
            }
        }
        result.append(HardwareDisplay(
                    name: name,
                    displayId: currentDisplayId,
                    serialNumber: CGDisplaySerialNumber(currentDisplayId),
                    width: CGDisplayPixelsHigh(currentDisplayId),
                    hight: CGDisplayPixelsWide(currentDisplayId)))
    }
    return result
 }

func getScreenNameBySerialName(_ serial: UInt32) -> String? {
    var object: io_object_t
    var serialPortIterator = io_iterator_t()
    let matching = IOServiceMatching("IODisplayConnect")
    let kernResult = IOServiceGetMatchingServices(kIOMasterPortDefault,
                                                  matching,
                                                  &serialPortIterator)
    if KERN_SUCCESS == kernResult && serialPortIterator != 0 {
        repeat {
            object = IOIteratorNext(serialPortIterator)
            let info = IODisplayCreateInfoDictionary(object, UInt32(kDisplayProductID) ?? 0)
                .takeRetainedValue() as NSDictionary as! [String: AnyObject]
            print(kDisplayVendorID)
            print(kDisplayProductID)
            if let productName = info["DisplayProductName"] as? [String: String],
                let firstKey = Array(productName.keys).first {
                 if info["DisplaySerialNumber"] as? UInt32 == serial {
                    IOObjectRelease(serialPortIterator)
                     return productName[firstKey]!
                 }
            }
        } while object != 0
    }
    IOObjectRelease(serialPortIterator)
    return nil
}

func getScreenOptions() -> [VideoOption] {
    var options: [VideoOption] = []
    let displayData = getDisplayData()
    for data in displayData {
        options.append(VideoOption(name: data.name, selected: false, displayID: data.displayId))
    }

    return options
}

func getAudioOptions() -> [AudioOption] {
    var options: [AudioOption] = []
    let audioDevices = AudioDeviceFinder.findDevices()
    for device in audioDevices ?? [] {
        options.append(AudioOption(name: device.name ?? "", selected: false, deviceId: device.uid ?? ""))
    }

    return options
}

struct VideoOption {
    var name: String
    var selected: Bool
    var displayID: CGDirectDisplayID
}

struct AudioOption {
    var name: String
    var selected: Bool
    var deviceId: String
}

struct menuState {
    var bar: String = kBarStateInitial
    var duration: String = "20 minutes"
    var sound: String = "Purr"
    var color: String = "Dark"
    var screen: [VideoOption]
    var audio: [AudioOption]
}

class MenuState {
    var state = menuState(screen: getScreenOptions(), audio: getAudioOptions())
    var defaults = UserDefaults.init(suiteName: "Flowcus")
    init() {
        state.bar = kBarStateInitial
        state.color = defaults?.string(forKey: "color") ?? state.color
        state.duration = defaults?.string(forKey: "duration") ?? state.duration
        state.sound = defaults?.string(forKey: "sound") ?? state.sound
    }

    func setBar(bar: String) {
        state.bar = bar
     }

    func getBar() -> String {
        return state.bar
    }

    func setColor(color: String) {
        state.color = color
        defaults?.set(state.color, forKey: "color")

    }

    func getColor() -> String {
        return state.color
    }

    // https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/color/
    // and convert by dividing by 255
    func getCGColor(name: String) -> CGColor {
        let defaultColor = NSColor.init(red: 0, green: (122/255), blue: 1, alpha: 1.0).cgColor
        let colors = [
            "Blue": defaultColor,
            "Green":  NSColor.init(red: (52/255), green: (199/255), blue: (89/255), alpha: 1).cgColor,
            "Indigo":NSColor.init(red: (88/255), green: (85/255), blue: (214/255), alpha: 1).cgColor,
            "Orange":NSColor.init(red: (255/255), green: (149/255), blue: (0/255), alpha: 1).cgColor,
            "Pink": NSColor.init(red: (255/255), green: (45/255), blue: (85/255), alpha: 1).cgColor,
            "Purple": NSColor.init(red: (175/255), green: (82/255), blue: (222/255), alpha: 1).cgColor,
            "Red": NSColor.init(red: 1, green: (59/255), blue: (48/255), alpha: 1).cgColor,
            "Teal": NSColor.init(red: (90/255), green: (200/255), blue: (250/255), alpha: 1).cgColor,
            "Yellow": NSColor.init(red: (255/255), green: (204/255), blue: (0/255), alpha: 1).cgColor
        ]
        return colors[name, default: defaultColor]
    }
    func setDuration(duration: String) {
        state.duration = duration
        defaults?.set(state.duration, forKey: "duration")

    }

    func getDuration() -> String {
        return state.duration
    }

    func setSound(sound: String) {
        state.sound = sound
        defaults?.set(state.sound, forKey: "sound")

    }

    func getSound() -> String {
        return state.sound
    }

    func getState() -> menuState {
        return state
    }

    func getScreen() -> [VideoOption] {
        return state.screen
    }

    func getAudioDevices() -> [AudioOption] {
        return state.audio
    }
    func selectScreen(title: String) {
        var selectedName = ""
        for option in state.screen where option.selected {
            selectedName = option.name
        }
        for index in 0 ..< state.screen.count {
            state.screen[index].selected = false
            if state.screen[index].name == title {
                state.screen[index].selected = selectedName != title
            }
        }
    }
    
    func selectAudio(uid: String) {
        for index in 0 ..< state.audio.count {
            state.audio[index].selected = false
            if state.audio[index].deviceId == uid {
                state.audio[index].selected = true
            }
        }
    }

    func getSelectedDisplayId() -> CGDirectDisplayID? {
        for option in state.screen where option.selected {
            return option.displayID
        }
        return nil
    }
    
    func getSelectedAudioId() ->  AVCaptureDevice? {
        for option in state.audio where option.selected {
            return AVCaptureDevice.init(uniqueID: option.deviceId)
        }
        return nil
    }
}
