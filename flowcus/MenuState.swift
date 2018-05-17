//
//  MenuState.swift
//  flowcus
//
//  Created by Alfonso on 03.05.18.
//  Copyright © 2018 CafeConCodigo. All rights reserved.
//
import Cocoa
import Foundation

struct menuState {
    var bar: String = kBarStateInitial
    var duration: String = "20 minutes"
    var sound: String = "Purr"
    var color: String = "Dark"
}

class MenuState {
    var state = menuState()
    var defaults = UserDefaults.init(suiteName: "flowcus")
    init() {
        state.bar = kBarStateInitial
        state.color = defaults?.string(forKey: "color") ?? "Green"
        state.duration = defaults?.string(forKey: "duration") ?? "20 minutes"
        state.sound = defaults?.string(forKey: "sound") ?? "Tink"
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
    func getCGColor(name: String) -> CGColor {
        let darkColor = NSColor(red: 0.137, green: 0.137, blue: 0.137, alpha: 1.00)
        switch name {
        case "Dark":
            return darkColor.cgColor
        case "Red":
            return NSColor.red.cgColor
        case "Green":
            return NSColor.green.cgColor
        case "Yellow":
            return NSColor.yellow.cgColor
        case "Purple":
            return NSColor.purple.cgColor
        default:
            return darkColor.cgColor
        }
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
}
