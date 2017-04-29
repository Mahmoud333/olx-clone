//
//  FancyTextView.swift
//  olx Game
//
//  Created by Mahmoud Hamad on 3/30/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit

@IBDesignable
class FancyTextView: UITextView {

    @IBInspectable var CornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = CornerRadius
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
