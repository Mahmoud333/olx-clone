//
//  addAdImageCell.swift
//  olx Game
//
//  Created by Mahmoud Hamad on 3/30/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit

class addAdImageCell: UICollectionViewCell {
    
    @IBOutlet weak var theImageView: UIImageView!
    
    func configuerCellAddImages(){
        theImageView.backgroundColor = C.ourGreen
        theImageView.image = UIImage(named: "add-image")
        theImageView.contentMode = .scaleAspectFit
        theImageView.layer.cornerRadius = 22
    }
    
    func configuerCellImagesCell(img: UIImage){
        self.theImageView.image = img
        theImageView.contentMode = .scaleAspectFill
        theImageView.layer.cornerRadius = 22
        theImageView.clipsToBounds = true
        
    }
}
