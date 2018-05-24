//
//  AppDelegate.swift
//  flowcus
//
//  Created by Alfonso on 28.04.18.
//  Copyright © 2018 Codefulness. All rights reserved.
//

import Cocoa
import AVFoundation
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

let kBarStateInitial = "initial"
let kBarStateComplete = "complete"
let kBarStatePaused = "paused"
let kBarStateInProgress = "inProgress"
let barHeight = 3

func coregraphicsReconfiguration(display:CGDirectDisplayID, flags:CGDisplayChangeSummaryFlags, userInfo:UnsafeMutableRawPointer?) -> Void
{
    print("Core Graphics Reconfiguration")
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate, NSWindowDelegate {
    @IBOutlet weak var window: NSWindow!
    
    var mState = MenuState()
    var player: AVAudioPlayer?
    var timeMenuItems = [NSMenuItem]()
    var timerInterval = 0
 
    let v: NSView = {
        let view =  NSView(frame: NSRect(x: 0, y: 0, width: 0, height: barHeight))
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
    var version: String?
    var build: String?
    
    func applicationDidResignActive(_ notification: Notification) {
        window.makeKey()
        window.orderFront(self)
        window.makeMain()
        window.orderFrontRegardless()
        
        // Get version and build
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.version = version
        }
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            self.build = build
        }
        
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        makeWindowTransparentAndAlwaysOnTop()
        let visibleFrame = NSScreen.main!.visibleFrame
        let frame = NSRect(x: visibleFrame.minX, y: visibleFrame.maxY, width: visibleFrame.width, height:  CGFloat(integerLiteral: barHeight))
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
        
        CGDisplayRegisterReconfigurationCallback(coregraphicsReconfiguration, nil)

        
        // appcenter.ms
        MSAppCenter.start("0922e4fb-d702-4e89-95bf-89cd1dcc8eb8", withServices:[
            MSAnalytics.self,
            MSCrashes.self
        ])
        MSAnalytics.trackEvent("Open App")
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
        window.level = .floating
        window.hasShadow = false
        window.titlebarAppearsTransparent = true
        window.standardWindowButton(.closeButton)?.isHidden = true
        window.standardWindowButton(.zoomButton)?.isHidden = true
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window?.styleMask.insert(.fullSizeContentView)
        window.ignoresMouseEvents = true
    }
    
     func windowWillEnterFullScreen(_ notification: Notification) {
        print("full screen.....!!")
    }
}
