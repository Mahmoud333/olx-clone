//
//  PostCell.swift
//  olx Game
//
//  Created by Mahmoud Hamad on 3/17/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit
import DTImageScrollView
import Alamofire
import AlamofireImage
import Firebase

//Stopped Using It - Stopped Using It - Stopped Using It - Stopped Using It - Stopped Using It

class PostCell: UITableViewCell, DTImageScrollViewDatasource {

    @IBOutlet weak var imageScrollView: DTImageScrollView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellPrice: UILabel!
    @IBOutlet weak var cellDate: UILabel!
    @IBOutlet weak var cellLocation: UILabel!
    
    var post: Post!
    
    var imagess = [UIImage]()
    var imagesURLS = [URL]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    //Stopped Using It - Stopped Using It - Stopped Using It - Stopped Using It - Stopped Using It
    func configuerCell(post: Post){
        self.post = post
        print("SMGL: 1")
        cellTitle.text = post.title
        cellPrice.text = post.price
        cellDate.text = post.createdIn
        cellLocation.text = post.location
        
        
        
        if post.imageUrls != nil {
            imagesURLS.removeAll()
            imagess.removeAll()
            for imageURL in post.imageUrls {
                print("SMGL: \(FIRStorage.storage().reference())")
                print("SMGL: \(imageURL)")
                print("SMGL: \(FIRStorage.storage().reference(forURL: imageURL))")
                /*
                 let url = URL(string: imageURL)
                 imagesURLS.append(url!)
                 
                 if self.imagesURLS.count == self.post.imageUrls.count {
                 self.imageScrollView.datasource = self
                 self.imageScrollView.show()
                 }*/
                
                //img cached
                if let img = FeedVC.imageCache.object(forKey: imageURL as NSString) {
                    
                    imagess.append(img)
                    if self.imagess.count == self.post.imageUrls.count { //finished all images
                        self.imageScrollView.show()
                    }
                    print("SMGL: image found in cache")
                    
                } else { //not cached
                    
                    
                    
                    let ref = FIRStorage.storage().reference(forURL: imageURL)  //the url doesn't change but have to do it like this to do it and get photo
                    print("SMGL: 11")
                    print("SMGL: ImageURL \(imageURL)")
                    print("SMGL: ref: \(ref)")
                    print("SMGL: ref.fullPath: \(ref.fullPath)")
                    print("SMGL: ref.bucket: \(ref.bucket)")
                    
                    ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in //download img
                        
                        print("SMGL: 111")
                        
                        if error != nil {
                            print("SMGL: Unable to download image from firebase storage")
                        } else {
                            print("SMGL: Image Downloaded from firebase storage")
                            
                            if let imageData = data {
                                if let img = UIImage(data: imageData) {
                                    
                                    self.imagess.append(img)
                                    print("SMGL: 2")
                                    FeedVC.imageCache.setObject(img, forKey: imageURL as NSString)//cache it
                                    
                                    print("SMGL: downloaded image and appended in array and cached")
                                    
                                    if self.imagess.count == self.post.imageUrls.count {
                                        self.imageScrollView.show()
                                    }
                                }
                            }
                        }
                    })
                }
            }
        }
        self.imageScrollView.datasource = self
        if self.superview != nil {
            self.imageScrollView.placeholderImage = UIImage(named: "placeholder")
        }
    }
    //Stopped Using It - Stopped Using It - Stopped Using It - Stopped Using It - Stopped Using It
    func loadTheImages(){

    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func numberOfImages() -> Int {
        print("SMGL: 3")
        //return imagesURLS.count ?? 0
        return imagess.count ?? 0

    }
    
    func imageForIndex(index: Int) -> UIImage { //SMGL
        print("SMGL: 4")
        return imagess[index]
    }
    //Stopped Using It - Stopped Using It - Stopped Using It - Stopped Using It - Stopped Using It
    //SMGL
    func imageURL(index: Int) -> URL {
        
        return imagesURLS[index]
        /*
        if index == 1 {
            return NSURL(string: post.imageUrls[0] )! as URL
        } else if index == 2 {
            return NSURL(string: post.imageUrls[1])! as URL
        } else if index == 3 {
            return NSURL(string: post.imageUrls[2])! as URL
        } else if index == 4 {
            return NSURL(string: post.imageUrls[3])! as URL
        } else {
            return NSURL(string: "")! as URL
        }*/
    }
    
}
