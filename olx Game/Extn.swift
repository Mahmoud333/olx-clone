//
//  Extn.swift
//  olx Game
//
//  Created by Mahmoud Hamad on 3/16/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit

extension UIScrollViewDelegate {
    var lastContentOffsetSMGL: CGPoint {
        get{ return lastContentOffsetSMGL ?? CGPoint(x: 0, y: 0)}
        set{ lastContentOffsetSMGL = newValue}
    }

}

extension UITextField: UITextFieldDelegate {
    func addDoneBtnToolbarSMGL() {
        var doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default //important change color
        var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        /*
        var uiview = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        var viewtextfield = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        uiview.addSubview(viewtextfield)
        var textfield = UIBarButtonItem(customView: uiview)
        */
        var done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: Selector("doneButtonAction"))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        //items.append(textfield)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }

    func doneButtonAction() {
        self.resignFirstResponder()
    }
    func changeReturnToDoneSMGL(){
        self.returnKeyType = .done
        self.delegate = self
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        /*if textField == someTextField { // Switch focus to other text field
            otherTextField.becomeFirstResponder()
        }*/
        self.resignFirstResponder()
        return true
    }
}

extension UIViewController {
    
    func errorAlertSMGL(titleString: String,errorString: String) {
        let messageText = errorString
        let titleText = titleString
        let ac = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    func getDateAndTimeSMGL() -> String {
        // get the current date and time
        let currentDateTime = Date()
        
        // get the user's calender
        let userCalender = Calendar.current
        
        // choose which date and time components are needed
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second
        ]
        
        //get the components
        let dateTimeComponents = userCalender.dateComponents(requestedComponents, from: currentDateTime)
        
        //return "\(dateTimeComponents.hour!):\(dateTimeComponents.minute!):\(dateTimeComponents.second!) - \(dateTimeComponents.day!)/\(dateTimeComponents.month!)/\(dateTimeComponents.year!)"
        //hour:minute:seconds - day/month/year
        
        return "\(dateTimeComponents.hour!):\(dateTimeComponents.minute!) - \(dateTimeComponents.day!)/\(dateTimeComponents.month!)/\(dateTimeComponents.year!)"
        //hour:minute - day/month/year
        
        // now the components are available
        /*
         dateTimeComponents.year   // 2016
         dateTimeComponents.month  // 10
         dateTimeComponents.day    // 8
         dateTimeComponents.hour   // 22
         dateTimeComponents.minute // 42
         dateTimeComponents.second // 17
         */
    }
}

