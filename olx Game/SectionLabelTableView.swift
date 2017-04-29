//
//  SectionLabelTableView.swift
//  olx Game
//
//  Created by Mahmoud Hamad on 4/28/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit

class SectionLabelTableView: UILabel {

    var topInset: CGFloat = 0
    var rightInset: CGFloat = 10
    var bottomInset: CGFloat = 0
    var leftInset: CGFloat = 10
    
    override func drawText(in rect: CGRect) {
        //super.drawText(in: rect) //had to remove it bec. it completley destroyed how it looked
        
        let insets: UIEdgeInsets = UIEdgeInsets(top: self.topInset, left: self.leftInset, bottom: self.bottomInset, right: self.rightInset)
        self.setNeedsLayout()
        
        //self.textColor =
        //self.backgroundColor =
        
        //self.backgroundColor = UIColor.clear

        self.lineBreakMode = .byWordWrapping
        self.numberOfLines = 0
        
        return super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    

}
