//
//  TableCollectionViewCell.swift
//  olx Game
//
//  Created by Mahmoud Hamad on 3/25/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit

class TableCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var createdInLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    var post: Post?
    
    func configuerCell(post: Post,img: UIImage){
        self.post = post
        
        imageView.image = img
        titleLabel.text = post.title
        
        let price = Double(post.price)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.string(from: NSNumber(value: price!))
        
        priceLabel.text = "\(String(describing: numberFormatter))"
        createdInLabel.text = post.createdIn
        locationLabel.text = post.location
    }
}
