//
//  AppDelegate+Handlers.swift
//  flowcus
//
//  Created by Alfonso on 02.05.18.
//  Copyright © 2018 Codefulness. All rights reserved.
//

import Cocoa
import AVFoundation
import AppCenterAnalytics

extension AppDelegate {
    
    @objc func updateMenuTime() {
        return
        // let useTime = resumeTime > 0 ? resumeTime : self.timeStarts
        if   mState.getBar() == kBarStateInProgress {
            let animationLeft = Int(CACurrentMediaTime()) -  self.timeStarts
            let secondsLeft = durationMap[mState.getDuration()]! - animationLeft
            statusItem.menu?.items[0].title = "𝓕lowcus  [\(secondsLeft.toAudioString)]"
        } else if mState.getBar() == kBarStatePaused {
            let animationLeft = Int(CACurrentMediaTime()) -   timeWhenPaused
            let secondsLeft = durationMap[mState.getDuration()]! - animationLeft
            statusItem.menu?.items[0].title = "𝓕lowcus  [\(secondsLeft.toAudioString)]"
        }
    }
    // When pressing on pause/resume from the menu
    @objc func pauseResume() {
        let barState = mState.getState()
        if mState.getBar() == kBarStateInProgress {
            timeWhenPaused = Int(CACurrentMediaTime())
            v.layer?.pauseAnimation()
            mState.setBar(bar: kBarStatePaused)
            renderMenu(state: mState.getState())
            timer.invalidate()
            MSAnalytics.trackEvent("Pause Bar", withProperties: [
                "duration": barState.duration,
                "sound": barState.sound,
                "color": barState.color,
            ])
        } else if mState.getBar() == kBarStatePaused {
            resumeTime = Int(CACurrentMediaTime()) - timeWhenPaused
            v.layer?.resumeAnimation()
            mState.setBar(bar: kBarStateInProgress)
            renderMenu(state: mState.getState())
            MSAnalytics.trackEvent("Resume Bar", withProperties: [
                "duration": barState.duration,
                "sound": barState.sound,
                "color": barState.color,
            ])
        }
    }

    @objc func stop() {

        if mState.getBar() == kBarStatePaused {
            mState.setBar(bar: kBarStateInitial)
            DispatchQueue.main.async {
                self.v.layer?.resumeAnimation()
                self.v.alphaValue = 0
                self.v.layer?.removeAllAnimations()
                self.v.frame = NSRect(x: 0, y: 0, width: 0, height: barHeight)
                self.v.alphaValue = 1
            }
        } else {
            mState.setBar(bar: kBarStateInitial)
            DispatchQueue.main.async {
                self.v.alphaValue = 0
                self.v.layer?.removeAllAnimations()
                self.v.frame = NSRect(x: 0, y: 0, width: 0, height: barHeight)
                self.v.alphaValue = 1
            }
        }
        renderMenu(state: mState.getState())
        let barState = mState.getState()
        MSAnalytics.trackEvent("Stop Bar", withProperties: [
            "duration": barState.duration,
            "sound": barState.sound,
            "color": barState.color,
        ])
    }
    
    func updateUI(asyncClosure: @escaping (() -> ())) {
        DispatchQueue.main.async {
            NSAnimationContext.runAnimationGroup({ (context: NSAnimationContext!) -> Void in
                context.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionLinear)
                context.duration = TimeInterval(durationMap[self.mState.getDuration()]!)
                context.allowsImplicitAnimation = true
                // context.timingFunction = CAMediaTimingFunction
                self.v.frame = NSRect(x: 0, y: 0, width: Int((self.window.contentView?.bounds.width)!), height: barHeight)
            }, completionHandler:  asyncClosure)
        }
    }
    @objc func startRestart() {
        mState.setBar(bar: kBarStateInProgress)
        let s = mState.getBar()
        renderMenu(state: mState.getState())
        timeStarts = Int(CACurrentMediaTime())
        resumeTime = 0
        // timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateMenuTime), userInfo: nil, repeats: true)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateMenuTime), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
 
        v.frame = NSRect(x: 0, y: 0, width: 0, height: CGFloat(integerLiteral: barHeight))
        v.layer?.backgroundColor = mState.getCGColor(name: mState.getColor())
        let playSoundAndNotify: (() -> ()) = {
            DispatchQueue.main.async {
                let barState = self.mState.getState()
                if (barState.bar == kBarStateInProgress) {
                    self.showNotification()
                    self.sound?.volume = 0.7
                    self.sound?.play()
                    self.mState.setBar(bar: kBarStateComplete)
                    self.renderMenu(state: self.mState.getState())
                    MSAnalytics.trackEvent("Complete Bar", withProperties: [
                        "duration": barState.duration,
                        "sound": barState.sound,
                        "color": barState.color,
                    ])
                }
            }
        }
        

        updateUI(asyncClosure: playSoundAndNotify)
        let barState = self.mState.getState()
        MSAnalytics.trackEvent("Start Bar", withProperties: [
            "duration": barState.duration,
            "sound": barState.sound,
            "color": barState.color,
        ])
    }

    @objc func changeSound(sender: Any) {
        let prevBarState = self.mState.getState()
        let selectedItem = (sender as! NSMenuItem)
        let selectedSound = NSSound(named: NSSound.Name(rawValue: selectedItem.title))
        selectedSound?.volume = 0.5
        selectedSound?.play()
        sound = selectedSound
        mState.setSound(sound: selectedItem.title)
        renderMenu(state: mState.getState())
        let barState = self.mState.getState()
        MSAnalytics.trackEvent("Change Sound", withProperties: [
            "duration": barState.duration,
            "sound": barState.sound,
            "prev sound": prevBarState.sound,
            "color": barState.color,
        ])
    }

    @objc func changeColor(sender: Any) {
        let prevBarState = self.mState.getState()
        let selectedColorTitle = (sender as! NSMenuItem).title
        mState.setColor(color: selectedColorTitle)
        renderMenu(state: mState.getState())

        v.layer?.backgroundColor = mState.getCGColor(name: selectedColorTitle)
        let barState = self.mState.getState()
        MSAnalytics.trackEvent("Change Color", withProperties: [
            "duration": barState.duration,
            "sound": barState.sound,
            "prev color": prevBarState.color,
            "color": barState.color,
        ])

    }

    @objc func changeDuration(sender: Any) {
        // showNotificationConfirm()
        let prevBarState = self.mState.getState()
        let selectedItem = (sender as! NSMenuItem)
        
        mState.setDuration(duration: selectedItem.title)
        renderMenu(state: mState.getState())
        let barState = self.mState.getState()
        MSAnalytics.trackEvent("Change Duration", withProperties: [
            "prev duration": prevBarState.duration,
            "duration": barState.duration,
            "sound": barState.sound,
            "color": barState.color,
        ])

     }
    @objc func quitApplication(sender: Any) {
        let barState = self.mState.getState()
        MSAnalytics.trackEvent("Quit Application", withProperties: [
            "duration": barState.duration,
            "sound": barState.sound,
            "color": barState.color,
            "bar": barState.bar,
        ])
        NSApp.terminate(nil)
    }
    
    @objc func changeScreen(sender: Any) {
        let selectedItem = (sender as! NSMenuItem)
        print(selectedItem.title)
    }
}
