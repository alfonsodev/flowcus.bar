//
//  AppDelegate+menu.swift
//  flowcus
//
//  Created by Alfonso on 02.05.18.
//  Copyright © 2018 Codefulness. All rights reserved.
//

import Cocoa

let durationMap = [
    "1 minute": 60 * 1,
    "5 minutes": 60 * 5,
    "10 minutes": 60 * 10,
    "15 minutes": 60 * 15,
    "20 minutes": 60 * 20,
    "25 minutes": 60 * 25,
    "30 minutes": 60 * 30,
    "35 minutes": 60 * 35,
    "40 minutes": 60 * 40,
    "45 minutes": 60 * 45,
    "50 minutes": 60 * 50,
    "55 minutes": 60 * 55,
    "60 minutes": 60 * 60
]

//let mapStateTitle = [
//    kBarStateInitial: "Start 𝓕lowcus",
//    kBarStateInProgress: "Restart 𝓕lowcus",
//]

extension AppDelegate {
    func getVolumeItem() {
        // setup volume
        // let slider = NSSlider(value: 5, minValue: 0, maxValue: 10, target: self, action: #selector(changeVolume(sender:)))
        // slider.numberOfTickMarks = 10
        // slider.allowsTickMarkValuesOnly = true
        // let volItem = NSMenuItem()
        // volItem.view = slider
        // menu.addItem(volItem)
    }

    func getDurationItems(enabled: Bool) -> [NSMenuItem] {
        var items = [NSMenuItem]()
        let sortedMap = durationMap.sorted { $0.value < $1.value }
        for element in sortedMap {
            let i = NSMenuItem(title: element.key, action: #selector(changeDuration(sender:)), keyEquivalent: "")
            if !enabled {
                i.isEnabled = false
                i.action = nil
            }
            items.append(i)
        }
        return items
    }

    func controlMenu(state: String) -> [NSMenuItem] {
        switch state {
        case kBarStateInProgress:
            return [
                NSMenuItem(title: "Stop", action: #selector(stop), keyEquivalent: "R"),
                NSMenuItem(title: "Pause", action: #selector(pauseResume), keyEquivalent: "")
            ]
        case kBarStatePaused:
            return [
                NSMenuItem(title: "Stop", action: #selector(stop), keyEquivalent: "R"),
                NSMenuItem(title: "Resume", action: #selector(pauseResume), keyEquivalent: "")
            ]
        default:
            return [ NSMenuItem(title: "Start", action: #selector(startRestart), keyEquivalent: "R") ]
        }
    }

    func renderMenu(state: menuState) {
        let menu = NSMenu()
        menu.removeAllItems()
        let colorMenu = NSMenu()
        menu.addItem(NSMenuItem(title: "𝓕lowcus \(Bundle.main.releaseVersionNumberPretty)", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())

        let controlItems = controlMenu(state: state.bar)
        for cItem in controlItems {
            menu.addItem(cItem)
        }
        // menu.addItem(NSMenuItem(title: "\(durations[selectedDurationIndex].toAudioString) left", action:nil, keyEquivalent: ""))
        // menu.addItem(NSMenuItem(title: "Stop", action: nil, keyEquivalent: ""))
        let barState = mState.getState().bar
        let enableMenu = barState == kBarStateComplete || barState == kBarStateInitial
        menu.addItem(NSMenuItem.separator())
        let durationItems = getDurationItems(enabled: enableMenu)
        for item in durationItems {
            menu.addItem(item)
        }
        // Color selector
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Color", action: #selector(changeDuration), keyEquivalent: "c"))
        menu.addItem(NSMenuItem(title: "Sound", action: nil, keyEquivalent: "S"))
        menu.setSubmenu(getSoundMenu(), for: menu.item(withTitle: "Sound")!)

        // Capture Screen Selector
        let screenMenu = getScreenMenu()

        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Capture Screen", action: nil, keyEquivalent: ""))
        menu.setSubmenu(screenMenu, for: menu.item(withTitle: "Capture Screen")!)

        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApplication), keyEquivalent: "q"))
        for (index, value) in menu.items.enumerated() {
            value.tag = index
        }

        // submenu Color
        // colorMenu.autoenablesItems = false
        let colorTitles = ["Blue", "Dark", "Red", "Green", "Yellow", "Purple"]
        for title in colorTitles {
            let item = NSMenuItem()
            item.title = title
            item.target = self
            item.action = #selector(changeColor(sender:))
            item.image = NSImage(named: NSImage.Name(rawValue: title.lowercased()))
            colorMenu.addItem(item)
        }

        colorMenu.item(withTitle: state.color)?.state = .on
        let colorItem = menu.item(withTitle: "Color")
        menu.item(withTitle: state.duration)?.state = .on
        timerInterval = 60 * 20
        menu.setSubmenu(colorMenu, for: colorItem!)
        statusItem.menu = menu
    }

    func getSoundMenu() -> NSMenu {
        let soundMenu = NSMenu()
        let soundsNames = ["Basso",
                           "Blow",
                           "Bottle",
                           "Frog",
                           "Funk",
                           "Glass",
                           "Hero",
                           "Morse",
                           "Ping",
                           "Pop",
                           "Purr",
                           "Sosumi",
                           "Submarine",
                           "Tink"]

        for sound in soundsNames {
            let soundItem = NSMenuItem()
            soundItem.title = sound
            soundItem.target = self
            soundItem.action = #selector(changeSound(sender:))
            soundMenu.addItem(soundItem)
        }
        // let soundItem = menu.item(withTitle: "Sound")
        let defaultSound = soundMenu.item(withTitle: mState.getSound())
        defaultSound?.state = .on

        return soundMenu
    }

    func getScreenMenu() -> NSMenu {
        let screenMenu = NSMenu()
        let screens = mState.getScreen()
        for screen in screens {
            let screenItem = NSMenuItem()
            screenItem.title = screen.name
            screenItem.target = self
            screenItem.action = #selector(changeScreen(sender:))
            if screen.selected {
                screenItem.state = .on
            }
            screenMenu.addItem(screenItem)
        }
        return screenMenu
    }
}
