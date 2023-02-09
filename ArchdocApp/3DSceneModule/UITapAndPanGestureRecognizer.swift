//
//  UITapAndPanGestureRecognizer.swift
//  ArchdocApp
//
//  Created by tixomark on 2/9/23.
//

import Foundation
import UIKit.UIGestureRecognizerSubclass

class UITapAndPanGestureRecognizer: UIPanGestureRecognizer {
    var numberOfTapsRequiredToInitiate: Int = 1
    private var lastTapDate: Date = Date()
    private var currentAmountOfTaps: Int = 0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if touches.count != 1 {
            state = .failed
        }

        if Date().timeIntervalSince(lastTapDate) <= 0.2 {
            currentAmountOfTaps += 1
        } else {
            currentAmountOfTaps = 0
//            state = .failed
        }
        lastTapDate = Date()
        
        if currentAmountOfTaps == numberOfTapsRequiredToInitiate {
            state = .began
            super.touchesBegan(touches, with: event)
        }
    }
}
