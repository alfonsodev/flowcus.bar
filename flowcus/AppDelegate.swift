//
//  AppDelegate.swift
//  flowcus
//
//  Created by Alfonso on 28.04.18.
//  Copyright © 2018 CafeConCodigo. All rights reserved.
//

import Cocoa
import AVFoundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate, NSWindowDelegate, CAMediaTiming {
    @IBOutlet weak var window: NSWindow!
    var player: AVAudioPlayer?
    var menu = NSMenu()
    let colorMenu = NSMenu()
    let soundMenu = NSMenu()
    var timeMenuItems = [NSMenuItem]()
    var timerInterval = 0
    var color = NSColor.red
    var darkColor = NSColor(red: 0.137, green: 0.137, blue: 0.137, alpha: 1.00)
    let v: NSView = {
        let view =  NSView(frame: NSRect(x: 0, y: 0, width: 0, height: 3))
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor(red: 0.137, green: 0.137, blue: 0.137, alpha: 1.00).cgColor
        view.layer?.cornerRadius = 0
        return view
    }()
    var sound = NSSound(named: NSSound.Name(rawValue: "Purr"))
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)

    func applicationDidResignActive(_ notification: Notification) {
        window.makeKey()
        window.orderFront(self)
        window.makeMain()
        window.orderFrontRegardless()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        makeWindowTransparentAndAlwaysOnTop()
        let frame = NSRect(x: 0, y: NSScreen.main!.frame.height, width: NSScreen.main!.frame.width, height: 3)
        window.setFrame(frame, display: true)
        window.makeKey()
        window.orderFront(self)
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        // https://stackoverflow.com/questions/33144721/transparent-nswindow-on-osx-el-capitan
        NSApplication.shared.activate(ignoringOtherApps: true)
        window.contentView?.addSubview(v)
        constructMenu()
        
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
        }
     }

    @objc func restart() {
        v.frame = NSRect(x: 0, y: 0, width: 0, height: 3)
        v.layer?.backgroundColor = color.cgColor
         DispatchQueue.main.async {
            NSAnimationContext.runAnimationGroup({ (context: NSAnimationContext!) -> Void in
                context.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
                context.duration = TimeInterval(self.timerInterval)
                context.allowsImplicitAnimation = true
                // context.timingFunction = CAMediaTimingFunction
                self.v.frame = NSRect(x: 0, y: 0, width: (self.window.contentView?.bounds.width)!, height: 3)
            }, completionHandler: {
                self.showNotification()
                self.sound?.volume = 0.5
                self.sound?.play()
            })

        }
    }
    
    func showNotification() -> Void {
        let notification = NSUserNotification()
        notification.title = "Test."
        notification.subtitle = "Sub Test."
        // notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.delegate = self as NSUserNotificationCenterDelegate
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter,
                                shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }


    @objc func changeSound(sender: Any) {
        let selectedItem = (sender as! NSMenuItem)
        
        let selectedSound = NSSound(named: NSSound.Name(rawValue: selectedItem.title))
        selectedSound?.volume = 0.5
        selectedSound?.play()
        sound = selectedSound
        for (_, value) in soundMenu.items.enumerated() {
            value.state = .off
        }
        
        selectedItem.state = .on
    }
    
    @objc func changeColor(sender: Any) {
        print("changing color ... ")
        let selectedColorTitle = (sender as! NSMenuItem).title
    
        for (_, value) in colorMenu.items.enumerated() {
            value.state = .off
        }
        
        switch selectedColorTitle {
        case "Dark":
            color =  darkColor
        case "Red":
            color = NSColor.red
            colorMenu.item(withTitle: "Red")?.state = .on
        case "Green":
            color = NSColor.green
            colorMenu.item(withTitle: "Green")?.state = .on
        case "Yellow":
            color = NSColor.yellow
            colorMenu.item(withTitle: "Yellow")?.state = .on
        case "Purple":
            color = NSColor.purple
            colorMenu.item(withTitle: "Purple")?.state = .on
        default:
            color = darkColor
        }
        v.layer?.backgroundColor = color.cgColor
    }

    @objc func setMinutes(sender: Any) {
        print(" tag is  \((sender as! NSMenuItem).tag).tag)")
        let selectedIndex = (sender as! NSMenuItem).tag
        let indexOfSelectedItem = menu.indexOfItem(withTag: selectedIndex)
        for index in 0...8 {
            let item = menu.item(at: index)
            item?.state = .off
        }
        let onItem = menu.item(at: indexOfSelectedItem )
        onItem?.state = .on
        
        switch (sender as! NSMenuItem).tag {
        case 2:
            timerInterval = 60 * 1
        case 3:
            timerInterval = 60 * 5
        case 4:
            timerInterval = 60 * 10
        case 5:
            timerInterval = 60 * 20
        case 6:
            timerInterval = 60 * 30
        case 7:
            timerInterval = 60 * 40
        case 8:
            timerInterval = 60 * 60
        default:
            timerInterval = 60 * 20
        }
    }
    
    func makeWindowVisibleWhenOtherAppsAreFullScreen() {
        
    }

    func makeWindowActiveWhenOtherWindowsAreSelected() {
        // https://github.com/electron/electron/issues/10078
    }

    func makeWindowTransparentAndAlwaysOnTop() {
        // Insert code here to initialize your application
        window.titlebarAppearsTransparent = true
        window.showsToolbarButton = false
        window.backgroundColor = NSColor.clear
        window.isOpaque = false
        window.title = ""
        window.level = NSWindow.Level.floating
        window.hasShadow = false
        window.titlebarAppearsTransparent = true
        window.standardWindowButton(.closeButton)?.isHidden = true
        window.standardWindowButton(.zoomButton)?.isHidden = true
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window?.styleMask.insert(.fullSizeContentView)
        window.ignoresMouseEvents = true
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    @objc func changeVolume(sender: Any) {
        
    }
    func constructMenu() {
        menu.addItem(NSMenuItem(title: "Start Flowcus", action: #selector(restart), keyEquivalent: "R"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "1 minute", action: #selector(setMinutes), keyEquivalent: "1"))
        menu.addItem(NSMenuItem(title: "5 minutes", action: #selector(setMinutes), keyEquivalent: "5"))
        menu.addItem(NSMenuItem(title: "10 minutes", action: #selector(setMinutes), keyEquivalent: "1m"))
        menu.addItem(NSMenuItem(title: "20 minutes", action: #selector(setMinutes), keyEquivalent: "2m"))
        menu.addItem(NSMenuItem(title: "30 minutes", action: #selector(setMinutes), keyEquivalent: "30"))
        menu.addItem(NSMenuItem(title: "40 minutes", action: #selector(setMinutes), keyEquivalent: "40"))
        menu.addItem(NSMenuItem(title: "1 hour", action: #selector(setMinutes), keyEquivalent: "h"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Color", action: #selector(setMinutes), keyEquivalent: "c"))
        
        // setup volume
//        let slider = NSSlider(value: 5, minValue: 0, maxValue: 10, target: self, action: #selector(changeVolume(sender:)))
//        slider.numberOfTickMarks = 10
//        slider.allowsTickMarkValuesOnly = true
//        let volItem = NSMenuItem()
//        volItem.view = slider
//
//        menu.addItem(volItem)
        
        setupSoundMenu()
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Flowcus v1.0.2", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        for (index, value) in menu.items.enumerated() {
            value.tag = index
        }
        
        setDefaultTime()
        statusItem.menu = menu

        // submenu Color
        // colorMenu.autoenablesItems = false
        let colorTitles = ["Dark", "Red", "Green", "Yellow", "Purple"]
        for title in colorTitles {
            let reditem = NSMenuItem()
            reditem.title = title
            reditem.target = self
            reditem.action = #selector(changeColor(sender:))
            reditem.image = NSImage(named: NSImage.Name(rawValue: title.lowercased()))
            colorMenu.addItem(reditem)
        }
        
        colorMenu.item(withTitle: "Dark")?.state = .on
        let colorItem = menu.item(withTitle: "Color")
        menu.setSubmenu(colorMenu, for: colorItem!)
    }
    
    

    func setDefaultTime () {
        let defaultItem = menu.item(withTitle: "20 minutes")
        defaultItem?.state = .on
        timerInterval = 60 * 20
    }

    func setupSoundMenu() {
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
        menu.addItem(NSMenuItem(title: "Sound", action: nil, keyEquivalent: "S"))
        let soundItem = menu.item(withTitle: "Sound")
        menu.setSubmenu(soundMenu, for: soundItem!)
        let defaultSound = soundMenu.item(withTitle: "Purr")
        defaultSound?.state = .on
    }

     func windowWillEnterFullScreen(_ notification: Notification) {
        print("full screen.....!!")
    }
    
    

}
