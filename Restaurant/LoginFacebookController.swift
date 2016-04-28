//
//  LoginFacebookController.swift
//  Restaurant
//
//  Created by user on 3/6/16.
//  Copyright © 2016 Imsi. All rights reserved.
//

import Foundation
import RealmSwift
import FBSDKLoginKit
import Alamofire
class LoginFacebookController:UIViewController, FBSDKLoginButtonDelegate{
    
    var userProfile: Results<UserProfile>!
    var isLogin = false

    
    @IBOutlet var loginView: FBSDKLoginButton! = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()

    override func viewDidLoad() {
        
        loginView.delegate = self
        loginView.hidden = true
        
        // Do any additional setup after loading the view.
        if let token = FBSDKAccessToken.currentAccessToken(){
            print(token)
            fetchProfile()
        }

        
    }
    func fetchProfile(){
        print("FetchProfile")
        let user_profile = UserProfile()
        user_profile.Authorization = ""
        user_profile.ContentType = ""
        
        let params = ["fields": "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: params).startWithCompletionHandler{(connection, result, error)->Void in
            if error != nil {
                print(error)
                return
            }
            if let id = result.valueForKey("id") as? String {
                print(id)
                user_profile.userId = id
            }
            if let firstName = result.valueForKey("first_name") as? String {
                print(firstName)
                user_profile.firstName = firstName
            }
            if let lastName = result.valueForKey("last_name") as? String {
                print(lastName)
                user_profile.lastName = lastName
            }
            if let email = result.valueForKey("email") as? String {
                print(email)
                
                
            }
            if let url_picture = result.valueForKey("picture")?.valueForKey("data")!.valueForKey("url") as? String {
                print(url_picture)
                let api = UserProfileAPI()
                let imageData = api.loadImageData(url_picture)
                user_profile.imageofUser = imageData
            }
            let realm = try! Realm()
            try! realm.write {
                realm.add(user_profile, update: true)
            }
            let user = realm.objects(UserProfile)
            debugPrint(user)
            self.isLogin = true
            let api = UserProfileAPI()
            api.postUserProfile(user[0], completion: self.didPosttoUser)
            
            self.performSegueWithIdentifier("AlreadyLogin", sender: self)
            
        }
    }
    func loadProfilefromRealm(){
        let realm = try! Realm()
        let user = realm.objects(UserProfile)
    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("Complete login")
        fetchProfile()
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        
        return true
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if "AlreadyLogin" == segue.identifier{
            
        }
    }
    func didPosttoUser(isPost:Bool){
        if(isPost){
            
        }
        else{
            //code for post failed
        }
        
        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
  
    
}