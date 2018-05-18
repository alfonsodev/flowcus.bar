//
//  Int+format.swift
//  flowcus
//
//  Created by Alfonso on 02.05.18.
//  Copyright © 2018 Codefulness. All rights reserved.
//

import Foundation

extension Int {
    var toAudioString: String {
        let h = self / 3600
        let m = (self % 3600) / 60
        let s = (self % 3600) % 60
        return h > 0 ? String(format: "%1d:%02d:%02d", h, m, s) : String(format: "%1d:%02d", m, s)
    }
}
