//
//  FeedVC.swift
//  olx Game
//
//  Created by Mahmoud Hamad on 3/17/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var sideBar:sideBar!
    var sidebarIsVisible = false
    var postss = [Post]()
    
    static var imageCache: NSCache <NSString, UIImage> = NSCache()
    //static bec. we gonna use it in multiple location Dict String key get image value
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let view1 = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20))
        view1.backgroundColor = HeaderView.backgroundColor
        view1.layer.zPosition = 6
        view.addSubview(view1)
        
        //headerView
        HeaderView.layer.zPosition = 2
        
        
        //sidebar
        sideBar.frame = CGRect(x: UIScreen.main.bounds.width, y: 20, width: 180, height: self.view.bounds.height)
        sideBar.layer.zPosition = 4
        //sideBar.center.y = self.view.center.y
        //sideBar.isHidden == true
        self.view.addSubview(sideBar)
        


        
        
        //observe our posts by url of our posts database
        //get array of posts
        //DataService.ds.REF_POSTS.observeSingleEvent(of: .value, with: { (snapshots) in
        DataService.ds.REF_POSTS.observe( .value, with: { (snapshots) in
            print("SMGL:Snapshots \(snapshots)")
            print("SMGL:snapshots.children.allObjects \(snapshots.children.allObjects)")
            self.postss.removeAll()
            
            //snapshot is many, its an array of all of our posts
            if let snapshot = snapshots.children.allObjects as? [FIRDataSnapshot] {
                print("SMGL: Snapshot \(snapshot)")
                
                for snap in snapshot {
                    print("SMGL: SnapKey: \(snap.key)")
                    print("SMGL: Snap: \(snap.value)")
                    
                    if let postData = snap.value as? Dictionary<String, Any> {
                        let snapKey = snap.key //170301-SMGL123-04-11-40
                        let post = Post(postKey: snapKey, postData: postData)
                        self.postss.append(post)
                    }
                }
                self.tableView.reloadData()
            }
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        //navigationController?.hidesBarsOnSwipe = true
    }
    
    var lastContentOffset = CGPoint(x: 0, y: 0)
    var hidden = false
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let height = HeaderView.frame.size.height
        let width = HeaderView.frame.size.width
        var xPosition = self.HeaderView.frame.origin.x
        //View will slide 20px up
        var yPosition = self.HeaderView.bounds.height
        
        var currentOffset = scrollView.contentOffset
        
        let viewsDictionary = ["HeaderView":HeaderView, "TableView": tableView]
        
        print("SMGL: lastContentoffSet \(self.lastContentOffset.y)")
        print("SMGL: currentoffSet \(currentOffset.y)")
        
        if currentOffset.y > self.lastContentOffset.y {
            print("Downward - things goes up")
            //Downward

            //Tableview
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.frame = CGRect(x: xPosition,
                                              y: 20,
                                              width: self.view.bounds.width,
                                              height: self.view.bounds.height-(50)-20)//"-20" zawed
            })
            
            //Header
            UIView.animate(withDuration: 0.3) {
                self.HeaderView.transform = CGAffineTransform(translationX: 0, y: -50)
            }
        }
        else { //if currentOffset.y < self.lastContentOffset.y
            print("Upward - things goes down")
            //Upward
            
            //header
            UIView.animate(withDuration: 0.3) {
                self.HeaderView.transform = CGAffineTransform(translationX: 0, y:0)
                
            }
            
            //tableview
            UIView.animate(withDuration: 0.3, animations: {
                self.tableView.frame = CGRect(x: xPosition,
                                              y: height,
                                              width: self.view.bounds.width,
                                              height: self.view.bounds.height-(50)-height)//"-height" zawed
                self.HeaderView.alpha = 1
            })

        }
        //view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[HeaderView]-[TableView]", options: [], metrics: nil, views: viewsDictionary))
        //tableView.updateConstraints()
        //view.setNeedsUpdateConstraints()
        //tableView.setNeedsDisplay()
        //view.setNeedsLayout()
        //tableView.setNeedsUpdateConstraints()
        self.lastContentOffset = currentOffset
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("SMGL: scrollViewWillBeginDragging")
    }
    @IBAction func filterPressed(_ sender: UIButton) {
        if sidebarIsVisible == false {
            //self.sideBar.isHidden = false
            print("filterPressed false")

            UIView.animate(withDuration: 0.4, animations: {
                //self.sideBar.transform = CGAffineTransform(translationX: self.view.bounds.width-180, y: 0)
                self.sideBar.frame = CGRect(x: UIScreen.main.bounds.width-180,//self.view.bounds.width-180,
                                              y: 20,
                                              width: 180,
                                              height: self.view.bounds.height)
            })
            sidebarIsVisible = true
        } else {
            print("filterPressed true")

            UIView.animate(withDuration: 0.4, animations: {
                //self.sideBar.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
                self.sideBar.frame = CGRect(x: UIScreen.main.bounds.width,//self.view.bounds.width,
                                            y: 20,
                                            width: 180,
                                            height: self.view.bounds.height)
            })
            //self.sideBar.isHidden = true
            sidebarIsVisible = false
        }
    }
}
//TableView
extension FeedVC {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt \(indexPath.row)")
        
        //pod
        /*
         if let cell = tableView.dequeueReusableCell(withIdentifier: C.indentifiers.PostCell.rawValue, for: indexPath) as? PostCell {
            
            print("SMGl: cellForRowAt \(indexPath.row)")
            print("SMGL: post \(postss[indexPath.row])")
            cell.configuerCell(post: postss[indexPath.row])
            
            return cell
         }
        */
        //Mine
            if let cell = tableView.dequeueReusableCell(withIdentifier: C.indentifiers.TableCellUICollection.rawValue, for: indexPath) as? tableUICollectionCell {
                
                print("SMGl: cellForRowAt \(indexPath.row)")
                print("SMGL: post \(postss[indexPath.row])")
                cell.configuerCell(post: postss[indexPath.row])
                
                return cell
            }
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell {
            
            print("SMGl: willDisplay Cell \(indexPath.row)")

        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postss.count ?? 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}
