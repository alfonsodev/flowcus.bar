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
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var window: NSWindow!
    var player: AVAudioPlayer?
    var menu = NSMenu()
    var timeMenuItems = [NSMenuItem]()
    var timerInterval = 0
    
    let v: NSView = {
        let view =  NSView(frame: NSRect(x: 0, y: 0, width: 0, height: 3))
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.red.cgColor
        view.layer?.cornerRadius = 0
        return view
    }()
    
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
        v.layer?.removeAllAnimations()
        v.frame = NSRect(x: 0, y: 0, width: 0, height: 3)
        animateView()
    }

    @objc func setMinutes(sender: Any) {
        print(" tag is  \((sender as! NSMenuItem).tag).tag)")
        let selectedIndex = (sender as! NSMenuItem).tag
        let indexOfSelectedItem = menu.indexOfItem(withTag: selectedIndex)
        for index in 0...6 {
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

    func constructMenu() {
        menu.addItem(NSMenuItem(title: "Restart Flowcus", action: #selector(restart), keyEquivalent: "R"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "1 minutes", action: #selector(setMinutes), keyEquivalent: "1"))
        menu.addItem(NSMenuItem(title: "5 minutes", action: #selector(setMinutes), keyEquivalent: "5"))
        menu.addItem(NSMenuItem(title: "10 minutes", action: #selector(setMinutes), keyEquivalent: "1m"))
        menu.addItem(NSMenuItem(title: "20 minutes", action: #selector(setMinutes), keyEquivalent: "2m"))
        menu.addItem(NSMenuItem(title: "30 minutes", action: #selector(setMinutes), keyEquivalent: "30"))
        menu.addItem(NSMenuItem(title: "40 minutes", action: #selector(setMinutes), keyEquivalent: "40"))
        menu.addItem(NSMenuItem(title: "1 hour", action: #selector(setMinutes), keyEquivalent: "h"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Flowcus", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        for (index, value) in menu.items.enumerated() {
            value.tag = index
        }
        
        setDefaultTime()
        
        statusItem.menu = menu
    }

    func setDefaultTime () {
        let defaultItem = menu.item(withTitle: "20 minutes")
        defaultItem?.state = .on
        timerInterval = 60 * 20
    }

    func animateView() {
        print("animation will start with time \(timerInterval)")
        NSAnimationContext.runAnimationGroup({ (context: NSAnimationContext!) -> Void in
            context.duration = TimeInterval(timerInterval)
            context.allowsImplicitAnimation = true
            v.frame = NSRect(x: 0, y: 0, width: (window.contentView?.bounds.width)!, height: 3)
        })
    }
}
