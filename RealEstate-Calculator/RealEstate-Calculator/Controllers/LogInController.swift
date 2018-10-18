//
//  LogInController.swift
//  RealEstate-Calculator
//
//  Created by timofey makhlay on 10/17/18.
//  Copyright © 2018 Timofey Makhlay. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    @IBOutlet weak var signInButtonByGoogle: GIDSignInButton!
    @IBAction func signInButtonPressed(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        print("Pressed Sign in")
        self.performSegue(withIdentifier: "toAllProperties", sender: self)
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let user = appDelegate.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signInSilently()
        

        // TODO(developer) Configure the sign-in button look/feel
        // ...
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
        if Auth.auth().currentUser != nil {
            // Access the storyboard and fetch an instance of the view controller
//            let storyboard = UIStoryboard(name: "Main", bundle: nil);
//            let viewController: ListPropertiesTableViewController = storyboard.instantiateViewController(withIdentifier: "toAllProperties") as! ListPropertiesTableViewController;
//
            // User is signed in.
            // ...
            print("User IS SIGNED IN")
            let user = Auth.auth().currentUser
            if let user = user {
                print("User == User")
                // The user's ID, unique to the Firebase project.
                // Do NOT use this value to authenticate with your backend server,
                // if you have one. Use getTokenWithCompletion:completion: instead.
                let uid = user.uid
                let email = user.email
                let photoURL = user.photoURL
                // ...
                self.performSegue(withIdentifier: "toAllProperties", sender: self)
            }
        } else {
            // No user is signed in.
            // ...
            print("No USER FOUND")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}

