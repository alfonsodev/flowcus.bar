//
//  MenuState.swift
//  flowcus
//
//  Created by Alfonso on 03.05.18.
//  Copyright © 2018 CafeConCodigo. All rights reserved.
//

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
        state.color = (defaults?.string(forKey: "color"))!
        state.bar = (defaults?.string(forKey: "bar"))!
        state.duration = (defaults?.string(forKey: "duration"))!
        state.sound = (defaults?.string(forKey: "sound"))!
    }
    
    func setBar(bar: String) {
        state.bar = bar
        defaults?.set(state.bar, forKey: "bar")
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
