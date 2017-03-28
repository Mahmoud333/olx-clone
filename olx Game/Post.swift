//
//  Post.swift
//  olx Game
//
//  Created by Mahmoud Hamad on 3/22/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import Foundation

class Post {
    
    private var _title: String!
    private var _caption: String!
    private var _imageUrl: String!
    private var _imagesURLS: [String]!
    
    private var _postKey: String!
    
    private var _createdIn: String!
    private var _location: String!
    private var _price: String!
    
    init(title: String?, caption: String?, imageUrl: String?, imagesURLS: [String]?, postKey: String?, createdIn: String?, location: String?, price: String?) {
        
        self._title = title
        self._caption = caption
        self._imageUrl = imageUrl
        self._imagesURLS = imagesURLS
        self._postKey = postKey
        self._createdIn = createdIn
        self._price = price
    }
    
    //when we get post
    init(postKey: String, postData: Dictionary<String, Any>) {
        //what we gonna use to convert the data we get from firebase into something we can use
        
        //postData could contain anything so we have to prepare for that
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        if let imagesURLS = postData["ImagesUrls"] as? [String] {
            self._imagesURLS = imagesURLS
        }
        if let title = postData["title"] as? String {
            self._title = title
        }
        if let createdIn = postData["created_in"] as? String {
            self._createdIn = createdIn
        }
        if let location = postData["location"] as? String {
            self._location = location
        }
        if let price = postData["price"] as? String {
            self._price = price
        }
    }
    
    var postKey: String {
        if _postKey == nil { return "" }
        return _postKey
    }
    var caption: String {
        if _createdIn == nil { return "" }
        return _caption
    }
    var imageUrls: [String] {
        if _imagesURLS == nil { return ["gs://olx-games.appspot.com/Ad-Images/a103eb2dc0ebe70231161f9cb71d308b.png"] }
        return _imagesURLS
    }
    var title: String {
        if _title == nil { return "" }
        return _title
    }
    var createdIn: String {
        if _createdIn == nil { return "" }
        return _createdIn
    }
    var location: String {
        if _location == nil { return "" }
        return _location
    }
    var price: String {
        if _price == nil { return "" }
        return _price
    }
}
