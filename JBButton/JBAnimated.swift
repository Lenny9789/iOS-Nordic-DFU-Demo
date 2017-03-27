//
//  JBAnimated.swift
//  JBButton
//
//  Created by Jérôme Boursier on 17/06/2016.
//  Copyright © 2016 Jérôme Boursier. All rights reserved.
//
import UIKit
// MARK:- Extension for animation stuff
private typealias JBAnimated = JBButton
public extension JBAnimated {
    
    /**
     Attachs animations to the layer of the button
     
     - parameter animations: a group of animations
     - parameter keyPath:    the key path
     */
    internal func launchAnimations(_ animations: CAAnimationGroup?, forGlobalKeyPath keyPath: String) {
        guard animations != nil else {
            return
        }
        self.layer.add(animations!, forKey: keyPath)
    }
    
    // MARK:- UIKit
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if self.highlight {
            self.backgroundColor = self.backgroundColor!.darkerColor()
        }
        
        self.launchAnimations(self.customTouchesBeganAnimations, forGlobalKeyPath: "touchesBegan")
    }
    
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.backgroundColor = self.originalBackgroundColor
        
        self.launchAnimations(self.customTouchesEndedAnimations, forGlobalKeyPath: "touchesEnded")
        
        self.delegate?.didTapOnButton?(self)
    }
}
