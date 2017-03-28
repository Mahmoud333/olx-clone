//
//  DropShadow Protocol.swift
//  olx Game
//
//  Created by Mahmoud Hamad on 3/15/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit

protocol DropShadow{}

extension DropShadow where Self: UIView {
    
    func addDropShadowSMGL(){
        
        layer.shadowColor = UIColor(red: C.SHADOW_GRAY, green: C.SHADOW_GRAY, blue: C.SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0 //How far it blurs out / shadow spans out
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0) //ta5od curve lt7t
    }
}
