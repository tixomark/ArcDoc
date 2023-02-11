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
    var maxTapIntervalInSeconds: Double = 0.5
    private var lastTapDate: Date!
    private var currentAmountOfTaps: Int = 0
    private var initialTapLocation: CGPoint!
    private var maximumDelta: CGFloat = 50
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if touches.count != 1 {
            state = .failed
            return
        }
        
        let view = touches.first?.view
        guard let touchLocation = touches.first?.location(in: view) else {
            state = .failed
            return
        }
        
        if initialTapLocation != nil && Date().timeIntervalSince(lastTapDate) <= maxTapIntervalInSeconds {
            
            let xTranslation = initialTapLocation.x - touchLocation.x
            let yTranslation = initialTapLocation.y - touchLocation.y
            let delta = sqrt(pow(xTranslation, 2) + pow(yTranslation, 2))

            if delta <= maximumDelta {
                currentAmountOfTaps += 1
                if currentAmountOfTaps == numberOfTapsRequiredToInitiate + 1 {
                    state = .began
                    super.touchesBegan(touches, with: event)
                }
            } else {
                initialTapLocation = nil
                currentAmountOfTaps = 0
                state = .failed
            }
        } else {
            initialTapLocation = touchLocation
            currentAmountOfTaps = 1
        }
        lastTapDate = Date()
    }
}
