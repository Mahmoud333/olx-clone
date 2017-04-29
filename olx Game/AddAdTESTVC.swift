//
//  AddAdTESTVC.swift
//  olx Game
//
//  Created by Mahmoud Hamad on 4/28/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit
import MapKit

class AddAdTESTVC: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Add 1")
        tableView.delegate = self
        print("Add 2")
        tableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

    var txtFieldTypes = ["Title", "Price"]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Add 3")
        if indexPath.row == 0 || indexPath.row == 1,indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as? TextFieldCell {
                
                print("Add 4")
                
                cell.TextField.placeholder = txtFieldTypes[indexPath.row]
                return cell
            }
        } else if indexPath.row == 2,indexPath.section == 0  {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewCell", for: indexPath) as? TextViewCell {
                print("Add 5")
                
                return cell
            }
        }else if indexPath.row == 0,indexPath.section == 1  {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath) as? MapCell {
                
                print("Add 6")
                return cell
            }
        }
        print("Add 7")
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        default:
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 1,indexPath.section == 0 { //text fieldds
            return CGFloat(60)
        } else if indexPath.row == 2,indexPath.section == 0 {                  //text view
            return CGFloat(140)
        } else if indexPath.row == 0,indexPath.section == 1 {               //map
            return CGFloat(170)
        }
        return 100
    }
    /*
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Location: the place where the item at or where you will sell the item at"
    }
     */
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return " "
    }
    /*
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.numberOfLines = 3
        header.textLabel?.textColor = UIColor.gray
        header.textLabel?.font = UIFont.systemFont(ofSize: 13)
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = .left
        
    }*/
    //will display footer view
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = SectionLabelTableView()
        label.text = "Location of the item at or where you will sell the item at."
        //label.backgroundColor = UIColor.magenta//tableView.backgroundColor
        label.backgroundColor = UIColor(white: 0.94, alpha: 0.5)
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 12)
        //label.lineBreakMode = .byWordWrapping
        //label.numberOfLines = 0
        return label
        
    }
    //view for footer
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat(0)
        }
        return CGFloat(26)
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat(10)
        }
        return CGFloat(30)
    }
 
    //estimated height for row
    //estimated height for header
    //estimated height for footer
}
