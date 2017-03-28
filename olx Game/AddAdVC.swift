//
//  AddAdVC.swift
//  olx Game
//
//  Created by Mahmoud Hamad on 3/22/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit
import Firebase


class AddAdVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //UINavigationControllerDelegate uses it to display imagepicker and dismiss it as well

    @IBOutlet weak var addImageBTN: UIButton!
    @IBOutlet weak var imageBtnV1: UIButton!
    @IBOutlet weak var imageBtnV2: UIButton!
    @IBOutlet weak var imageBtnV3: UIButton!
    @IBOutlet weak var imageBtnV4: UIButton!
    @IBOutlet weak var imageBtnV5: UIButton!
    
    @IBOutlet weak var titleTextField: JiroTextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var priceTextField: HoshiTextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    var imagePicker: UIImagePickerController!
    var changeButtonImage = false //check once we choose 1st image, the button image
    var color: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        color = addImageBTN.backgroundColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) { //can be video or image
        
        //get the image, array have original, edited & other info
        if let choosenImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            let addImage = UIImage(named: "add-image")
            let xImage = UIImage(named: "X")
            
            if addImageBTN.currentImage == UIImage(named: "add-image") {
                
                addImageBTN.setImage(choosenImage, for: .normal)
                
                imageBtnV1.isUserInteractionEnabled = true
                imageBtnV1.backgroundColor = color
                imageBtnV1.setImage(addImage, for: .normal)
                
            } else if imageBtnV1.currentImage == UIImage(named: "add-image") {
                
                imageBtnV1.setImage(choosenImage, for: .normal)
                
                imageBtnV2.isUserInteractionEnabled = true
                imageBtnV2.backgroundColor = color
                imageBtnV2.setImage(addImage, for: .normal)
            }else if imageBtnV2.currentImage == UIImage(named: "add-image") {
                
                imageBtnV2.setImage(choosenImage, for: .normal)
                
                imageBtnV3.isUserInteractionEnabled = true
                imageBtnV3.backgroundColor = color
                imageBtnV3.setImage(addImage, for: .normal)
            } else if imageBtnV3.currentImage == UIImage(named: "add-image") {
                
                imageBtnV3.setImage(choosenImage, for: .normal)
                
                imageBtnV4.isUserInteractionEnabled = true
                imageBtnV4.backgroundColor = color
                imageBtnV4.setImage(addImage, for: .normal)
            }else if imageBtnV4.currentImage == UIImage(named: "add-image") {
                
                imageBtnV4.setImage(choosenImage, for: .normal)
                
                imageBtnV5.isUserInteractionEnabled = true
                imageBtnV5.backgroundColor = color
                imageBtnV5.setImage(addImage, for: .normal)
            } else if imageBtnV5.currentImage == UIImage(named: "add-image") {
                
                imageBtnV5.setImage(choosenImage, for: .normal)
            }
        } else {
            print("SMGL: a valid image wasn't selected INFO:- \(info)")
            errorAlertSMGL(titleString: "Error",errorString: "a valid image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    } //when we select image dismiss the image picker
    
    @IBAction func postBtnTapped(_ sender: Any) {
        guard let title = titleTextField.text, title != "" else {
            let msg = "SMGL: Title is empty, write Something"
            print("SMGL: Title is empty, write Something")
            errorAlertSMGL(titleString: "Error",errorString: "SMGL: Title is empty, write Something")
            return
        }
        guard let desc = descriptionTextField.text, desc != nil else {
            let msg = "SMGL: Description is empty, write Something"
            print(msg)
            errorAlertSMGL(titleString: "Error",errorString: msg)
            return
        }
        guard let price = priceTextField.text, price != nil else {
            let msg = "SMGL: Price is empty, choose how much you pricing it"
            print(msg)
            errorAlertSMGL(titleString: "Error",errorString: msg)
            return
        }
        guard let location = locationTextField.text, location != nil else {
            let msg = "SMGL: Location is empty, choose where you will sell it or where is it"
            print(msg)
            errorAlertSMGL(titleString: "Error",errorString: msg)
            return
        }
        
        //prepare & upload images
        let allButtons = [addImageBTN, imageBtnV1, imageBtnV2, imageBtnV3, imageBtnV4, imageBtnV5]
        
        let addImage = UIImage(named: "add-image")
        let xImage = UIImage(named: "X")

        var imagesURLs = [String]()
        var btnsChecked = 0
        var imageswillbeuploaded = 0 //know how many btn images we will uplpad
        
        //know how many btn images we will uplpad
        for Btn in allButtons {
            if Btn?.currentImage != addImage, Btn?.currentImage != xImage { //there is image other than the placeholder
                imageswillbeuploaded += 1
            }
        }
        
        for Btn in allButtons {
            btnsChecked += 1
            print("SMGL: \(btnsChecked)")
            if Btn?.currentImage != addImage, Btn?.currentImage != xImage { //there is image other than the placeholder
                
                //convert to data JPEG and compress it
                if let imgData = UIImageJPEGRepresentation(Btn!.currentImage!, 0.1) { //1.0 best quality, 0.2 still looks good
                    
                    //create random string for image name
                    let imageUid = NSUUID().uuidString
                    
                    //tell firebase storage its jpeg we passing in, FB can infer that but sometimes he get it wrong
                    let metadata = FIRStorageMetadata()
                    metadata.contentType = "image/jpeg"
                    
                    //upload it
                    DataService.ds.REF_STORAGE_IMAGES.child(imageUid).put(imgData, metadata: metadata, completion: { (metadata, error) in
                        
                        if error != nil {
                            let msg = "SMGL: something wrong with uploading the image to firebase storage"
                            print(msg)
                            self.errorAlertSMGL(titleString: "Error",errorString: msg)
                        } else {
                            let msg = "SMGL: Successfully uploaded image to Firebase storage"
                            print(msg)
                            
                            let downloadURL = metadata?.downloadURL()?.absoluteString //get 100% good string for the url we can download it from
                            
                            print("SMGL: absoluteString URL \(downloadURL)")
                            
                            if let url = downloadURL {
                                imagesURLs.append(url)
                                
                                //cache the image
                                //FeedVC.imageCache.setObject(Btn!.currentImage!, forKey: "\(url)" as NSString)
                                
                                if btnsChecked == 6, imagesURLs.count == imageswillbeuploaded {
                                    print("Added Ad \(imagesURLs)")
                                    self.postToFirebase(imagesUrlsArray: imagesURLs)
                                    print("SMGL: postToFirebase is called \(btnsChecked) \(imagesURLs.count) \(imageswillbeuploaded)")
                                    self.errorAlertSMGL(titleString: "Success",errorString: msg)

                                } else {print("SMGL: in else \(btnsChecked) \(imagesURLs.count) \(imageswillbeuploaded)")}
                            }
                        }
                    })
                }
            }
        }
    }
    
    func postToFirebase(imagesUrlsArray: [String]) {
        let postData: Dictionary<String, Any> = [ "title": titleTextField.text,
                                                  "caption": descriptionTextField.text,
                                                  "price": priceTextField.text,
                                                  "location": locationTextField.text,
                                                  "created_in": getDateAndTimeSMGL(),
                                                  "ImagesUrls": imagesUrlsArray
        ]
    
        //childByAutoId() firebase create id for post on fly (random)
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(postData) //is other way of "updateChildValues" it removes anything with same id then put ours
        
        //done,
        //start cleaning our labels and stuff
        descriptionTextField.text = ""
        titleTextField.text = ""
        priceTextField.text = ""
        locationTextField.text = ""
        
        let addImage = UIImage(named: "add-image")
        let xImage = UIImage(named: "X")
        
        addImageBTN.setImage(addImage, for: .normal)

        let allButtons = [imageBtnV1, imageBtnV2, imageBtnV3, imageBtnV4, imageBtnV5]
        for Btn in allButtons {
            Btn.setImage(xImage, for: .normal)
            Btn.backgroundColor = UIColor.white
        }
        /*
        imageBtnV1.setImage(xImage, for: .normal)
        imageBtnV2.setImage(xImage, for: .normal)
        imageBtnV3.setImage(xImage, for: .normal)
        imageBtnV4.setImage(xImage, for: .normal)
        imageBtnV5.setImage(xImage, for: .normal)
        imageBtnV1.backgroundColor = UIColor.white
        imageBtnV2.backgroundColor = UIColor.white
        imageBtnV3.backgroundColor = UIColor.white
        imageBtnV4.backgroundColor = UIColor.white
        imageBtnV5.backgroundColor = UIColor.white
        */

    }

}
