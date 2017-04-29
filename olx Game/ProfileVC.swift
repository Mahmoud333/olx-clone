//
//  ProfileVC.swift
//  olx Game
//
//  Created by Mahmoud Hamad on 4/9/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class ProfileVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var firstNameTxtField: HoshiTextField!
    @IBOutlet weak var lastNameTxtField: HoshiTextField!
    
    @IBOutlet weak var emailTxtField: HoshiTextField!
    @IBOutlet weak var phoneNumbTxtField: HoshiTextField!
    @IBOutlet weak var locationTxtField: HoshiTextField!
    
    @IBOutlet weak var locationView: UIView!
    
    @IBOutlet weak var dateOfBirthBtn: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserInfo()
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func fetchUserInfo(){
        DataService.ds.REF_USER_CURRENT.observeSingleEvent(of: .value, with: { (snapshots) in
            print("SMGL:Profile \(DataService.ds.REF_USER_CURRENT)")
            print("SMGL:Profile Snapshots \(snapshots)")
            print("SMGL:Profile snapshots.children.allObjects \(snapshots.children.allObjects)")
            
            if let snapshot = snapshots.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    
                    print("SMGL: Profile Snap \(snap)")
                }
                
            }
            
            if let userData = snapshots.value as? Dictionary<String, Any> {
                print("SMGL: Profile userData \(userData)")
                
                //Profile Img
                do {
                    if let imgURL = userData["twitter_profile_Image_Url"] as? String {//twitter
                        
                        let url = URL(string: imgURL)
                        let data = try Data(contentsOf: url!)
                        self.profileImg.image = UIImage(data: data)
                    } else if let imgURL = userData["facebook_PhotoURL"] as? String  {//facebook
                        
                        let url = URL(string: imgURL)
                        let data = try Data(contentsOf: url!)
                        self.profileImg.image = UIImage(data: data)
                    }
                } catch let err as NSError {print("SMGL: profile error \(err.localizedDescription)")}
                
                //Email
                if let email = userData["us_email"] as? String { //ours
                    self.emailTxtField.text = email
                    
                } else if let email = userData["twitter_email"] as? String {
                    self.emailTxtField.text = email
                } else if let email = userData["Email"] as? String {
                    self.emailTxtField.text = email
                }
                
                //First Name & last Name
                if let fname = userData["us_first"] as? String, let lname = userData["us_last"] as? String { //ours
                    self.firstNameTxtField.text = fname
                    self.lastNameTxtField.text = lname
                    
                }else if let name = userData["facebook_name"] as? String {
                    let nameArr = name.components(separatedBy: " ")
                    let firstName = nameArr[0] ; let lastName = nameArr[1]
                    self.firstNameTxtField.text = firstName
                    self.lastNameTxtField.text = lastName
                } else if let name = userData["twitter_name"] as? String {
                    let nameArr = name.components(separatedBy: " ")
                    let firstName = nameArr[0] ; let lastName = nameArr[1]
                    self.firstNameTxtField.text = firstName
                    self.lastNameTxtField.text = lastName
                }
                
                //Phone Number
                if let pNumber = userData["us_phonenumber"] as? String { //ours
                    self.phoneNumbTxtField.text = pNumber
                }
                
                //location
                if let loct = userData["us_location"] as? String { //ours
                    self.locationTxtField.text = loct
                }
                
                //date of birth
                if let dateofbirth = userData["us_dateofbirth"] as? String {
                    self.dateOfBirthBtn.setTitle(dateofbirth, for: .normal)
                }
                
                if let locationGeoFire = userData["location-geoFire"] as? Dictionary<String, Any> {
                    
                    if let location = locationGeoFire["l"] as? [Double] {
                        
                        if let latitude = location[0] as? Double, let longitude = location[1] as? Double {
                            
                            
                            print("SMGL: Profile Loc \(locationGeoFire)")
                            print("SMGL: Profile Loc \(location)")
                            print("SMGL: Profile Loc \(latitude)")
                            print("SMGL: Profile Loc \(longitude)")
                            
                            self.mapView.isScrollEnabled = false
                            
                            
                            
                            //whenever the data gets loaded we wants to zoom the map in
                            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                            
                            let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)
                            //CLLocationCoordinate2D, latitudeMeters and LongitudeMeters (how zoomed is it) 200meters
                            
                            self.mapView.setRegion(coordinateRegion, animated: true)
                            
                            let anno = MKPointAnnotation()
                            anno.coordinate = coordinate
                            self.mapView.addAnnotation(anno)
                        }
                    }
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func updateProfileTapped(_ sender: Any) {
        
        guard let firstname = firstNameTxtField.text else {
            errorAlertSMGL(titleString: "error", errorString: "First Name Empty"); return
        }
        guard let lastname = lastNameTxtField.text else {
            errorAlertSMGL(titleString: "error", errorString: "Last Name Empty"); return
        }
        guard let email = emailTxtField.text else {
            errorAlertSMGL(titleString: "error", errorString: "Email Empty"); return
        }
        guard let phonenumber = phoneNumbTxtField.text else {
            errorAlertSMGL(titleString: "error", errorString: "Phone Number Empty"); return
        }
        guard let location = locationTxtField.text else {
            errorAlertSMGL(titleString: "error", errorString: "location Empty"); return
        }
        //guard for date of birth
        guard let dateofbirth = dateOfBirthBtn.currentTitle, dateOfBirthBtn.currentTitle != "mm - dd - yyyy" else {
            errorAlertSMGL(titleString: "error", errorString: "date of birth is empty"); return
        }

        
        //Not saving/doing the img yet
        let newUserData = [ "us_first" : firstname,
                            "us_last": lastname,
                            "us_email": email,
                            "us_phonenumber": phonenumber,
                            "us_location": location,
                            "us_dateofbirth": dateofbirth
                            //img
        ]
        
        DataService.ds.REF_USER_CURRENT.updateChildValues(newUserData)
    }

    let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 220, height: 250))
    @IBAction func dateOfBirthTapped(_ sender: Any) {
        let vc = UIViewController()//UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))//
        vc.preferredContentSize = CGSize(width: 220, height: 250)
        vc.view.addSubview(pickerView)
        
        let ac = UIAlertController(title: "Date Of Birth", message: "", preferredStyle: .alert)
        ac.setValue(vc, forKey: "contentViewController")
        ac.addAction(UIAlertAction(title: "Done", style: .default, handler: { [unowned self] (UIAlertAction) in
            let month = self.pickerView.selectedRow(inComponent: 0)
            let day = self.pickerView.selectedRow(inComponent: 1)
            let year = self.pickerView.selectedRow(inComponent: 2)
            
            self.dateOfBirthBtn.setTitle("\(self.months[month]) - \(self.days[day]) - \(self.getYear()-year)", for: .normal)
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(ac, animated: true, completion: nil)
        
        /*
        getData { (<#[Int]#>) in
            <#code#>
        }
        */
    }
    
    /*
    @IBAction func LocationOn(_ sender: UISwitch) {
//        let vc = UIViewController()
//        vc.preferredContentSize = CGSize(width: 240, height: 300)
//        vc.view.addSubview(locationView)
        
        
        locationView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.8, height: self.view.bounds.height * 0.7)
        locationView.center = view.center
        view.addSubview(locationView)
        transparentBTN.isHidden = false
        
        //present(vc, animated: true, completion: nil)
        //present(ac, animated: true, completion: nil)

    }
 */
    
    @IBAction func mapVGestureTapped(_ sender: Any) {//UITapGestureRecognizer
        
        //present(ChooseLocationVC, animated: true, completion: nil)
        //performSegue(withIdentifier: C.Segues.ProfileMapVToChooseLocationVC.rawValue, sender: sender)
    }
    let days = ["01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31", "32"]
    let months = ["01","02","03","04","05","06","07","08","09","10","11","12"]
}

extension ProfileVC {

    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return months[row]
        case 1: return days[row]
        case 2: return "\(getYear() - row)"
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 12
        case 1:
            return 32
        case 2:
            return 100
        default:
            return 0
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
}
