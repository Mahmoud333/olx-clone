//
//  tableUICollectionCell.swift
//  olx Game
//
//  Created by Mahmoud Hamad on 3/25/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit
import Firebase

class tableUICollectionCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var post: Post!
    
    var images = [UIImage]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self

    }
    
    func configuerCell(post: Post){ //URLS: [URL],
        
        
        self.post = post
        let URLS = post.imageUrls as [String]
        
        if URLS != nil {
            images.removeAll()
            for imageURL in URLS {
                
                //img cached
                if let img = FeedVC.imageCache.object(forKey: imageURL as NSString) {
                    
                    images.append(img)
                    if self.images.count == self.post.imageUrls.count { //finished all images
                        self.collectionView.reloadData()
                    }
                    print("SMGL: image found in cache")
                    
                } else { //not cached
                
                print("SMGL: \(FIRStorage.storage().reference())")
                print("SMGL: \(imageURL)")
                print("SMGL: \(FIRStorage.storage().reference(forURL: imageURL))")
                
                //                let url = URL(string: imageURL)
                //                imagesURLS.append(url!)
                
                //                if self.imagesURLS.count == self.post.imageUrls.count {
                //                    self.imageScrollView.datasource = self
                //                    self.imageScrollView.show()
                //                }
                
                //img cached
                if let img = FeedVC.imageCache.object(forKey: imageURL as NSString) {
                    
                    images.append(img)
                    if self.images.count == self.post.imageUrls.count { //finished all images
                        //self.imageScrollView.show()
                        self.collectionView.reloadData()
                    }
                } else { //not cached
                    
                    let url = URL(string: imageURL)
                    let ref = FIRStorage.storage().reference(forURL: imageURL)  //the url doesn't change but have to do it like this to do it and get photo
                    print("SMGL: 11")
                    print("SMGL: url: \(url)")
                    print("SMGL: ImageURL \(imageURL)")
                    print("SMGL: ref: \(ref)")
                    print("SMGL: ref.fullPath: \(ref.fullPath)")
                    print("SMGL: ref.bucket: \(ref.bucket)")
                    
                    
                    //imagesURLS.append(ref)
                    ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in //download img
                        
                        print("SMGL: 111")
                        
                        if error != nil {
                            print("SMGL: Unable to download image from firebase storage")
                        } else {
                            print("SMGL: Image Downloaded from firebase storage")
                            
                            if let imageData = data {
                                if let img = UIImage(data: imageData) {
                                    
                                    self.images.append(img)
                                    FeedVC.imageCache.setObject(img, forKey: imageURL as NSString)//cache it
                                    
                                    print("SMGL: downloaded image and appended in array and cached")
                                    
                                    if self.images.count == self.post.imageUrls.count {
                                        self.collectionView.reloadData()
                                    }
                                }
                            }
                        }
                    })
                    }
                }
            }
        }
        self.collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //Collection View
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: C.indentifiers.TableCellUICollectionCell.rawValue, for: indexPath) as? TableCollectionViewCell {
            
            cell.configuerCell(post: post,img: images[indexPath.row])
            
            return cell
        }
        return UICollectionViewCell()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count ?? 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
}
