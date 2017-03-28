//
//  DTImageScrollView.swift
//  DTImageScrollView
//
//  Created by Daron Tancharoen on 8/1/16.
//
//

import UIKit
import AlamofireImage

public protocol DTImageScrollViewDatasource: class {
    func imageForIndex(index:Int) -> UIImage
    func imageURL(index:Int) -> URL
    func numberOfImages() -> Int
}

open class DTImageScrollView: UIView, UIScrollViewDelegate {

    open let scrollView = UIScrollView()
    open let pageControl = UIPageControl()
    open var placeholderImage: UIImage?
    
    open weak var datasource: DTImageScrollViewDatasource?
    
    open func show() {
        setup()
    }
    
    func setup() {
        // add scrollview
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.bounces = false
        self.scrollView.delegate = self
        self.addSubview(self.scrollView)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view":self.scrollView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: ["view":self.scrollView]))
        
        // add page control
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.pageControl)
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: self.pageControl, attribute: .centerX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.pageControl, attribute: .bottom, multiplier: 1, constant: 0))
        
        // add photos
        reloadPhotos()
    }
    
    open func reloadPhotos() {
        // remove old ImageViews (if any)
        for view in self.scrollView.subviews {
            view.removeFromSuperview()
        }
        
        // add photos to scrollView
        for index in 0..<self.datasource!.numberOfImages() {
            let imageView = UIImageView()
            imageView.tag = index+1
            imageView.image = self.placeholderImage
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = self.placeholderImage
            //imageView.af_setImage(withURL: self.datasource!.imageURL(index: index))
            imageView.image = self.datasource!.imageForIndex(index: index)
            self.scrollView.addSubview(imageView)
            
            // add constraints
            // height
            self.scrollView.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .height, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: 1, constant: 0))
            // width
            self.scrollView.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .width, relatedBy: .equal, toItem: imageView, attribute: .width, multiplier: 1, constant: 0))
            // top
            self.scrollView.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .top, relatedBy: .equal, toItem: imageView, attribute: .top, multiplier: 1, constant: 0))
            // bottom
            self.scrollView.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .bottom, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1, constant: 0))
            if index == 0 {
                // left to scrollview
                self.scrollView.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .left, relatedBy: .equal, toItem: imageView, attribute: .left, multiplier: 1, constant: 0))
            } else {
                // left to right of previous view
                let previouseImageView = self.viewWithTag(index)!
                self.scrollView.addConstraint(NSLayoutConstraint(item: previouseImageView, attribute: .right, relatedBy: .equal, toItem: imageView, attribute: .left, multiplier: 1, constant: 0))
            }
            if index == self.datasource!.numberOfImages()-1 {
                // right to scrollview
                self.scrollView.addConstraint(NSLayoutConstraint(item: self.scrollView, attribute: .right, relatedBy: .equal, toItem: imageView, attribute: .right, multiplier: 1, constant: 0))
            }
        }
        
        // update page control
        self.pageControl.numberOfPages = self.datasource!.numberOfImages()
        self.pageControl.currentPage = 0
        
        // layoutIfNeeded()
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // update pageController
        let pageWidth = scrollView.frame.size.width
        let fractionalPage = Float(scrollView.contentOffset.x / pageWidth)
        let page = Int(roundf(fractionalPage))
        self.pageControl.currentPage = page
    }
}


