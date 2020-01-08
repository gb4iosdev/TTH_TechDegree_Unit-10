//
//  VisualEffectView.swift
//  NASA
//
//  Created by Gavin Butler on 30-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

extension UIView {
    
    //Add blurr effect to the view.  Used in Eye in the Sky component when user is resetting location search
    func addBlurrEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.6
        self.addSubview(blurEffectView)
    }
    
    //Remove all blurr effects from the view.
    func removeBlurrEffect() {
        for subView in self.subviews {
            if subView is UIVisualEffectView {
                subView.removeFromSuperview()
            }
        }
    }
}
