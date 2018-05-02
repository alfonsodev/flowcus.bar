//
//  CALayer+PauseAnimation.swift
//  flowcus
//
//  Created by Alfonso on 01.05.18.
//  Copyright © 2018 CafeConCodigo. All rights reserved.
//

//
//  CALayer+PauseAnimation.swift
//  QQMusic_Swift3.0
//
//  Created by Yue Zhou on 2/21/18.
//  Copyright © 2018 Yue Zhou. All rights reserved.
//

import Cocoa

extension CALayer {
    
    func pauseAnimation() {
        let pauseTime = self.convertTime(CACurrentMediaTime(), from: nil)
        self.speed = 0.0
        self.timeOffset = pauseTime
    }
    
    
    func resumeAnimation() {
        let pauseTime = self.timeOffset
        self.speed = 1.0
        self.timeOffset = 0.0
        self.beginTime = 0.0
        let timeSincePause = self.convertTime(CACurrentMediaTime(), from: nil) - pauseTime
        self.beginTime = timeSincePause
    }
}
