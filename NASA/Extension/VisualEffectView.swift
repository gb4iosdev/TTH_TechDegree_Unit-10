//
//  VisualEffectView.swift
//  NASA
//
//  Created by Gavin Butler on 30-12-2019.
//  Copyright © 2019 Gavin Butler. All rights reserved.
//

import UIKit

extension UIView {
    
    func addBlurrEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.6
        self.addSubview(blurEffectView)
    }
    
    func removeBlurrEffect() {
        for subView in self.subviews {
            if subView is UIVisualEffectView {
                subView.removeFromSuperview()
            }
        }
    }
}
