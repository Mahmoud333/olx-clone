//
//  LocationV.swift
//  olx Game
//
//  Created by Mahmoud Hamad on 4/18/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit
import MapKit

class LocationV: UIView {

    @IBOutlet weak var mapView: MKMapView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 14
        
        mapView.layer.cornerRadius = 6
    }
    @IBAction func Cancel(_ sender: Any) {
        self.removeFromSuperview()
    }
}
