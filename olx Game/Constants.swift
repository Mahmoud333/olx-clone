//
//  Constants.swift
//  olx Game
//
//  Created by Mahmoud Hamad on 3/15/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit

struct C {
    
    static let SHADOW_GRAY: CGFloat = 120.0/255.0 //Color For Shadow
    
    static let KEY_UID = "uid"
    
    enum Segues: String {
        case FromSignInToFeed = "goToFeed"
    }
    
    enum indentifiers: String {
        case PostCell = "PostCell"
        case TableCellUICollection = "tableCell1"
        case TableCellUICollectionCell = "tableCell2"
        case SidebarCell = "SidebarCell"
    }
    
}
