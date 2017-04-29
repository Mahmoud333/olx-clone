//
//  MapCell.swift
//  olx Game
//
//  Created by Mahmoud Hamad on 4/28/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit

class MapCell: UITableViewCell {

    @IBOutlet weak var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mapView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
