//
//  ViewController.swift
//  olx Game
//
//  Created by Mahmoud Hamad on 3/15/17.
//  Copyright © 2017 Mahmoud SMGL. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

import TwitterKit
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailTextField: FancyTextField!
    @IBOutlet weak var passwordTextField: FancyTextField!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        //toolbar
        //emailTextField.addDoneBtnToolbarSMGL()
        //passwordTextField.addDoneBtnToolbarSMGL()
        //done button
        emailTextField.changeReturnToDoneSMGL()
        passwordTextField.changeReturnToDoneSMGL()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let existed_uid = KeychainWrapper.standard.string(forKey: C.KEY_UID) {
            print("SMGL: ID found in the keychain ")
            
            //update last login
            DataService.ds.createFirebaseDBUser(uid: existed_uid, userData: ["lastLogin": getDateAndTimeSMGL()])
            performSegue(withIdentifier: C.Segues.FromSignInToFeed.rawValue, sender: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func twitterBtnPressed(_ sender: Any) {
        print("SMGL: Twitter Btn Pressed")
        
        Twitter.sharedInstance().logIn(withMethods: [.webBased]) { (session, error) in
            print("SMGl: LoginCompletion")
            
            if let error = error {
                self.errorAlertSMGL(titleString: "Error",errorString: error.localizedDescription)
            }
            
            if session != nil { //success
                let authToken = session?.authToken
                let authTokenSecret = session?.authTokenSecret
                
                print("SMGL: UserName \(session?.userName)")
                
                let credential = FIRTwitterAuthProvider.credential(withToken: authToken!, secret: authTokenSecret!)
                
                let user = TWTRAPIClient.withCurrentUser()
                let request = user.urlRequest(withMethod: "GET",
                url: "https://api.twitter.com/1.1/account/verify_credentials.json",
                parameters: ["include_email": "true", "skip_status": "true"],
                error: nil)
                
                user.sendTwitterRequest(request, completion: { (response, data, error) in
                    
                    print("SMGL: Response:- [ \(response?.url) ]...SMGL: Data:-[ \(data) ]... SMGL: Error :-[ \(error) ]")
                    
                    if error != nil {
                        self.errorAlertSMGL(titleString: "Error",errorString: error!.localizedDescription)
                    }
                    
                    var json: Dictionary<String,Any>
                    
                    do {
                        json = try JSONSerialization.jsonObject(with: data!, options: []) as! Dictionary<String, Any>
                        
                        print("SMGL: Json response: ", json)
                        
                        let firstName = json["name"]
                        let lastName = json["screen_name"]
                        let email = json["email"]
                        
                        let empty = "empty could'nt get it"
                        
                        var userData1 = Dictionary<String, String>()
                        
                        userData1["lastLogin"] = self.getDateAndTimeSMGL()
                        userData1["provider"] = credential.provider
                        
                        if let profileImageURL = json["profile_image_url"] {
                            userData1["twitter_profile_Image_Url"] = "\(profileImageURL)" }
                        if let twitter_name = json["name"] {
                            userData1["twitter_name"] = "\(twitter_name)" }
                        if let twitter_email = json["email"] {
                            userData1["twitter_email"] = "\(twitter_email)" }
                        
                        if let twitter_screen_name = json["screen_name"] {
                            userData1["twitter_screen_name"] = "\(twitter_screen_name)" }
                        if let twitter_description = json["description"] {
                            userData1["twitter_description"] = "\(twitter_description)" }
                        
                        if let twitter_created_at = json["created_at"] {
                            userData1["twitter_created_at"] = "\(twitter_created_at)" }
                        if let twitter_profile_banner_url = json["profile_banner_url"] {
                            userData1["twitter_profile_banner_url"] = "\(twitter_profile_banner_url)" }
                        
                        if let twitter_followers_count = json["followers_count"] {
                            userData1["twitter_followers_count"] = "\(twitter_followers_count)" }
                        if let twitter_verified = json["verified"] {
                            userData1["twitter_verified"] = "\(twitter_verified)" }
                        if let twitter_location = json["location"] {
                            userData1["twitter_location"] = "\(twitter_location)" }
                        
                        self.firebaseAuth(credential, userData: userData1)
                    
                    } catch let error as NSError {
                        self.errorAlertSMGL(titleString: "error", errorString: error.localizedDescription)
                    }
                })
            }
        }
    }
    
    @IBAction func facebookBtnPressed(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            if error != nil { //there is error
                 print("SMGL: Unable to authenticate with Facebook:- \(error?.localizedDescription) ")
            
            } else if result?.isCancelled == true { //User canceled it
                print("SMGL: User canceled Facebook authentication ")
            
            } else {
                print("SMGL: Successfully authenticated with Facebook ")
                
                print("SMGL: result?.declinedPermissions: [\(result?.declinedPermissions as? String)]")
                
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                //credential to acccess token based on facebook authentication
                //basicaly you get the credential, and credential is whats used to authenticate with firebase
                
                //get alot of userData
                var fbRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
                fbRequest?.start(completionHandler: { (connection, result, error) in
                    
                    if error == nil { //no error
                        print("SMGL: User Info : \(result)")
                    } else {
                        print("SMGL: Error Getting Info \(error)");
                    }
                })
                
                self.firebaseAuth(credential, userData: nil)
            }
        }
        //"email" requesting permision just for the email request
    }

    //this part of proccess is the same for twitter, facebook, google & github & contains Firebase part only
    //Sign in Firebase using facebook credential
    func firebaseAuth(_ credential: FIRAuthCredential, userData: Dictionary<String, String>?) {
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            
            if error != nil { //there is error
                print("SMGL: Unable to authenticate with Firebase:- \(error?.localizedDescription) ")
                self.errorAlertSMGL(titleString: "Error",errorString: error!.localizedDescription)
            
            } else { //Success
                print("SMGL: Successfully authenticated with Firebase ") ; print("SMGl: credential:- \(credential) ")

                if let uid = user?.uid {
                    if userData == nil {
                        let userData2 = [ "provider": credential.provider,
                                          "lastLogin": self.getDateAndTimeSMGL(),
                                          "createdFirebase": self.getDateAndTimeSMGL(),
                                          "facebook_Email": user!.email!,
                                          "facebook_name": user!.displayName!,
                                          "facebook_PhotoURL": "\(user!.photoURL!)"
                        ] as Dictionary<String, String>
                        print("SMGL \(userData2)")
                        self.completeSignIn(uid: uid, userData: userData2)
                    } else {
                        self.completeSignIn(uid: uid, userData: userData!)
                    }
                }
            }
        })
    }
    //2 steps to authenticate in, with the provider then with firebase
    //1 tell facebook i allow to give my info to this app,2 checking if everything is ok then go ahead
    
    
    @IBAction func signupBtnPressed(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text { //they r not nil
            
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                
                if error != nil {
                    print("SMGL: Something Went completley wrong with authenticating with firebase using email :- \(error?.localizedDescription)")
                    self.errorAlertSMGL(titleString: "Error",errorString: error!.localizedDescription)
                
                } else { //we where able to create the user
                    print("SMGL: Successfully authenticated with Firebase [created the account]")
                    
                    if let uid = user?.uid {
                        let userData = ["Provider": "\(user?.providerID)",
                        "lastLogin": self.getDateAndTimeSMGL(),
                        "Email":  (user!.email),
                        "createdFirebase": self.getDateAndTimeSMGL()
                        ]
                        self.completeSignIn(uid: uid, userData: userData as! Dictionary<String, String>)
                    }
                }
            })
        } else {
            print("SMGL: either email or password are nil")
            errorAlertSMGL(titleString: "Error",errorString: "SMGL: either email or password are nil")
        }
    }
    
    @IBAction func signinBtnPressed(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text { //they r not nil
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                
                if error == nil { //no errors proceed, user existed & signed in
                    print("SMGL: Email user authenticated with firebase [Signed In]")
                    
                    if let uid = user?.uid { //leave last login
                        
                        let userData = ["lastLogin": self.getDateAndTimeSMGL()]
                        self.completeSignIn(uid: uid, userData: userData)
                    }
                    
                } else { //there is error //check firebase documentation //user doesn't exist
                    print("SMGL: There is error with signing in:- \(error?.localizedDescription)")
                    self.errorAlertSMGL(titleString: "Error",errorString: error!.localizedDescription)
                }
            })
        } else {
            print("SMGL: either email or password are nil ")
            errorAlertSMGL(titleString: "Error",errorString: "SMGL: either email or password are nil ")
        }
    }
    
    
    //save uid & perform segue
    func completeSignIn(uid: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: uid, userData: userData)
        KeychainWrapper.standard.set(uid, forKey: C.KEY_UID)
        print("SMGL: ")
        print("SMGL: data saved to keychain & will perform segue")
        print("SMGL: UserData: \(userData)")
        
        performSegue(withIdentifier: C.Segues.FromSignInToFeed.rawValue, sender: nil)
    }
}
