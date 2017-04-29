//
//  ChooseLocationVC.swift
//  olx Game
//
//  Created by Mahmoud Hamad on 4/19/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit
import MapKit
import Firebase

@IBDesignable
class ChooseLocationVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    
    let locationManager = CLLocationManager() //when working with locations we need to use location manager
    
    
    var geoFire: GeoFire! //geoFire Object
    var geoFireRef: FIRDatabaseReference! //geoFire reference
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.layer.cornerRadius = 14
        
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.follow //set tracking mode on the map (map will move with ur location if ur moving)

        //set geoFire
        geoFireRef = DataService.ds.REF_USER_CURRENT//FIRDatabase.database().reference()
        //now this has nothing to do with Geofire at this point this is just a firebase database reference, a reference to general database your app is using we just has to grab it and store it somewhere, we using it here since our app has 1 screen
        
        geoFire = GeoFire(firebaseRef: geoFireRef)
        //now this is a geoFire Thing, pass FireBaseReference
        //now GeoFire is initialized which is great!
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        gestureRecognizer.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(gestureRecognizer)
    }

    func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != .began {return}
        
        //remove all past annotations
        mapView.removeAnnotations(mapView.annotations)
        
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        //Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                if let pm = placemarks?[0] { //as! CLPlacemark
                    
                    let errorZ = ""
                    
                    // not all places have thoroughfare & subThoroughfare so validate those values
                    annotation.title = "\(pm.thoroughfare ?? errorZ) , \(pm.subThoroughfare ?? errorZ)"
                    annotation.subtitle = pm.subLocality
                    self.mapView.addAnnotation(annotation)
                    print(pm)
                }
            }
            else {
                annotation.title = "Unknown Place"
                self.mapView.addAnnotation(annotation)
                print("Problem with the data received from geocoder")
            }
            //places.append(["name":annotation.title,"latitude":"\(newCoordinates.latitude)","longitude":"\(newCoordinates.longitude)"])
        })
        
        //mapView.addAnnotation(annotation)
    }
    
    //check authorization
    func locationAuthStatus() { //when app in use not always save battery
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true //need to show user location on map
        
        } else { //we haven't given permission yet
            locationManager.requestWhenInUseAuthorization()
            //if they yes (didChangeAuthorization status) will get called
        }
    }
    
    //Delegate method
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.authorizedWhenInUse {    //YES
            mapView.showsUserLocation = true
        }
    }
    
    //background and button
    @IBAction func CancelIt(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    //button done
    @IBAction func Choosed(_ sender: Any) {
        if mapView.annotations.count != 0 {
            let theAnno = mapView.annotations[0]
            
            let location = theAnno.coordinate
            let locationSwift = CLLocation(latitude: location.latitude, longitude: location.longitude)
            
            geoFire.setLocation(locationSwift, forKey: "location-geoFire")
        }
    }


}
