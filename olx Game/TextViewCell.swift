//
//  TextViewCell.swift
//  olx Game
//
//  Created by Mahmoud Hamad on 4/28/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit

class TextViewCell: UITableViewCell {

    @IBOutlet weak var DescTextView: FancyTextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
