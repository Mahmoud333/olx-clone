//
//  sideBar.swift
//  olx Game
//
//  Created by Mahmoud Hamad on 3/28/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit

class sideBar: UIView, UITableViewDelegate, UITableViewDataSource, DropShadow {

    @IBOutlet weak var tableView: UITableView!
    

    var filterss = ["Most recent", "Price: L to H", "Price: H to L"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.dataSource = self
        tableView.delegate = self
        self.addDropShadowSMGL()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: C.indentifiers.SidebarCell.rawValue, for: indexPath) as? sideBarCells {
            cell.titleLabel.text = filterss[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterss.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
