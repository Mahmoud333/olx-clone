//
//  FuncyButton.swift
//  olx Game
//
//  Created by Mahmoud Hamad on 3/15/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit

@IBDesignable
class FancyButton: UIButton, DropShadow {

    @IBInspectable var CompletleyCircleIt: Bool = false {
        didSet {
            if CompletleyCircleIt {
                layer.cornerRadius = self.bounds.width/2
            } else {
                layer.cornerRadius = 0.0
            }
        }
    }
    
    @IBInspectable var CornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = CornerRadius
        }
    }
    
    @IBInspectable var addShadow: Bool = false {
        didSet {
            if addShadow == true {
                addDropShadowSMGL()
            }
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
