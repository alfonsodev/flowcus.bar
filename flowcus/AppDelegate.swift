//
//  AppDelegate.swift
//  flowcus
//
//  Created by Alfonso on 28.04.18.
//  Copyright © 2018 CafeConCodigo. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    let progressBar = NSProgressIndicator(frame: NSRect(x: 0, y: 0, width: NSScreen.main!.frame.width, height: 100))

    func applicationDidResignActive(_ notification: Notification) {
        window.makeKey()
        window.orderFront(self)
        window.makeMain()
        window.orderFrontRegardless()
        progressBar.controlTint = NSControlTint.graphiteControlTint

    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        makeWindowTransparentAndAlwaysOnTop()
        let frame = NSRect(x: 0, y: NSScreen.main!.frame.height, width: NSScreen.main!.frame.width, height: 53)
        window.setFrame(frame, display: true)
        window.makeKey()
        window.orderFront(self)
        
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        
        // https://stackoverflow.com/questions/33144721/transparent-nswindow-on-osx-el-capitan
        
        NSApplication.shared.activate(ignoringOtherApps: true)
        setupProgressBar()
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
    
    func setupProgressBar() {
        
        progressBar.minValue = 0
        progressBar.maxValue = 100
        progressBar.doubleValue = 0
        progressBar.controlTint = NSControlTint.graphiteControlTint
        // progressBar.setValue(10, forKey: "progress")
        // progressBar.increment(by: 50)
        
        window.contentView?.addSubview(progressBar)
    }
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

