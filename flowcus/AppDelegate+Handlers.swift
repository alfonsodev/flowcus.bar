//
//  AppDelegate+Handlers.swift
//  flowcus
//
//  Created by Alfonso on 02.05.18.
//  Copyright © 2018 CafeConCodigo. All rights reserved.
//

import Cocoa
import AVFoundation

extension AppDelegate {

    @objc func pauseResume() {
        if mState.getBar() == kBarStateInProgress {
            timeWhenPaused = Int(CACurrentMediaTime())
            v.layer?.pauseAnimation()
            mState.setBar(bar: kBarStatePaused)
            renderMenu(state: mState.getState())
            
        } else if mState.getBar() == kBarStatePaused {
            resumeTime = Int(CACurrentMediaTime()) - timeWhenPaused
            v.layer?.resumeAnimation()
            mState.setBar(bar: kBarStateInProgress)
            renderMenu(state: mState.getState())
        }
    }

    @objc func stop() {
        if mState.getBar() == kBarStatePaused {
            DispatchQueue.main.async {
                self.v.layer?.resumeAnimation()
                self.v.alphaValue = 0
                self.v.layer?.removeAllAnimations()
                self.v.frame = NSRect(x: 0, y: 0, width: 0, height: 3)
                self.v.alphaValue = 1
            }
        } else {
            DispatchQueue.main.async {
                self.v.alphaValue = 0
                self.v.layer?.removeAllAnimations()
                self.v.frame = NSRect(x: 0, y: 0, width: 0, height: 3)
                self.v.alphaValue = 1
            }

        }
        mState.setBar(bar: kBarStateInitial)
        renderMenu(state: mState.getState())
    }

    @objc func startRestart() {
        mState.setBar(bar: kBarStateInProgress)
        renderMenu(state: mState.getState())
        timeStarts = Int(CACurrentMediaTime())
        resumeTime = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateMenuTime), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        
        v.frame = NSRect(x: 0, y: 0, width: 0, height: 3)
        v.layer?.backgroundColor = color.cgColor
        
        DispatchQueue.main.async {
            NSAnimationContext.runAnimationGroup({ (context: NSAnimationContext!) -> Void in
                context.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
                context.duration = TimeInterval(durationMap[self.mState.getDuration()]!)
                context.allowsImplicitAnimation = true
                // context.timingFunction = CAMediaTimingFunction
                self.v.frame = NSRect(x: 0, y: 0, width: (self.window.contentView?.bounds.width)!, height: 3)
            }, completionHandler: {
                self.showNotification()
                self.sound?.volume = 0.7
                self.sound?.play()
                self.mState.setBar(bar: kBarStateComplete)
            })
        }
    }

    @objc func changeSound(sender: Any) {
        let selectedItem = (sender as! NSMenuItem)
        let selectedSound = NSSound(named: NSSound.Name(rawValue: selectedItem.title))
        selectedSound?.volume = 0.5
        selectedSound?.play()
        sound = selectedSound
        mState.setSound(sound: selectedItem.title)
        renderMenu(state: mState.getState())
    }

    @objc func changeColor(sender: Any) {
        let selectedColorTitle = (sender as! NSMenuItem).title
        mState.setColor(color: selectedColorTitle)
        renderMenu(state: mState.getState())
        
        switch selectedColorTitle {
        case "Dark":
            color =  darkColor
        case "Red":
            color = NSColor.red
        case "Green":
            color = NSColor.green
        case "Yellow":
            color = NSColor.yellow
        case "Purple":
            color = NSColor.purple
        default:
            color = darkColor
        }
        v.layer?.backgroundColor = color.cgColor
    }

    @objc func changeDuration(sender: Any) {
        let selectedItem = (sender as! NSMenuItem)
        
        mState.setDuration(duration: selectedItem.title)
        renderMenu(state: mState.getState())
        
     }

}
