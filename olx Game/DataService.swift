//BY Mahmoud333
// Singleton class
//is an instance of a class and is global accessible there's only one instance u could be in viewcontoller 406 u can still references this and its same instance as viewcontroller 1
//just a single instance thats why its called singleton
//how to make it singleton? "static let ds = DataService()" essentially referencing itself that line alone creates the singleton, static, global, everyone have access to it, use it wherever u r in app
//
//How u refrence Firebase database is by urls of ur database
//if u made GET request for the highest point it will fetch the whole database which we won't do, all u need to know whatever object you choose to make get request for you will get all the below it
//to get posts u have to separate them with "/" it will be like this mainURL/test/posts

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = FIRDatabase.database().reference()
//which is the url of our root database but from google.plist "https://olx-games.firebaseio.com/"

let STORAGE_BASE = FIRStorage.storage().reference() //gs://olx-games.appspot.com


class DataService {
    
    static let ds = DataService()
    
    //Private Common end points
    //DB refrences
    private var _REF_POSTS = DB_BASE.child("Posts") //.child means "/"
    private var _REF_USERS = DB_BASE.child("Users")
    
    //Storage refrences
    private var _REF_STORAGE_IMAGES = STORAGE_BASE.child("Ad-Images")
    
    
    //Public 
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_STORAGE_IMAGES: FIRStorageReference {
        return _REF_STORAGE_IMAGES
    }
    var REF_USER_CURRENT: FIRDatabaseReference { //get current user from keychain, matches uid
        let uid = KeychainWrapper.standard.string(forKey: C.KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }
    
    //Funcs
    
    //create user in data base func code, DBUser refer to database
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        
        //1. refrence where we will write this data
        REF_USERS.child(uid).updateChildValues(userData) //if uid (account) is not there firebase will create it, then pass the userData in it
        
        
        //.updateChildValues (userData) does: if things does not exist it will write it & if it does exist it wont override it, it will just add the new data to it. if it is not already over there, but .setValue func will override it and wibe old thing if the user already existed
    }
    
    func createAPost(uid: String, postData: Dictionary<String,String>){
        
        REF_POSTS.child(uid).setValue(postData)
        
        //other way of "updateChildValues" it removes anything with same id then put ours which we need
        //in our case so we dont merge posts with each other
    }
}

















































































