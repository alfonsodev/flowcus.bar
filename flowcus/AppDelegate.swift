//
//  AppDelegate.swift
//  flowcus
//
//  Created by Alfonso on 28.04.18.
//  Copyright © 2018 CafeConCodigo. All rights reserved.
//

import Cocoa
import AVFoundation

let kBarStateInitial = "initial"
let kBarStateComplete = "complete"
let kBarStatePaused = "paused"
let kBarStateInProgress = "inProgress"

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate, NSWindowDelegate {
    @IBOutlet weak var window: NSWindow!
    var mState = MenuState()
    var player: AVAudioPlayer?
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
    var timeStarts = 0
    var timer = Timer()
    
    var selectedDurationIndex = 3
     var timeWhenPaused = 0
    var resumeTime = 0
    
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
        renderMenu(state: mState.getState())
        
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("f"))
        }
    }
    
    @objc func updateMenuTime() {
        let useTime = resumeTime > 0 ? resumeTime : self.timeStarts
        let animationLeft = Int(CACurrentMediaTime()) - useTime
//        let secondsLeft = durationMap[selectedDurationIndex] - animationLeft
//        if secondsLeft > 0 && mState.getBar() == kBarStateInProgress {
//            updateTimerMenu(title: "Pause  \(secondsLeft.toAudioString) left")
//        } else if mState.getBar() == kBarStatePaused {
//            let time = durations[selectedDurationIndex] - timeWhenPaused
//            updateTimerMenu(title: "Pause  \(time.toAudioString) left")
//        }
    }
    
    func showNotification() -> Void {
        let notification = NSUserNotification()
        notification.title = "𝓕lowcus."
        notification.subtitle = "✅ Complete"
        NSUserNotificationCenter.default.delegate = self as NSUserNotificationCenterDelegate
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter,
                                shouldPresent notification: NSUserNotification) -> Bool {
        return true
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
    
     func windowWillEnterFullScreen(_ notification: Notification) {
        print("full screen.....!!")
    }
}
