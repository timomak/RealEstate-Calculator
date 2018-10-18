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

// TODO: Handle UserDefualts sync from Firebase to Userdefaults after Login

class LoginController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    // Connect to Firebase Database
    var ref: DatabaseReference!
    @IBOutlet weak var signInButtonByGoogle: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect Google Sign in from delegate and Sign in user.
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signInSilently()
        
        // TODO: Configure the sign-in button look/feel
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
        if Auth.auth().currentUser != nil {
            // User is signed in.
            let user = Auth.auth().currentUser
            
            if let user = user {
                print("User found and Authenticated.")
                // Save user info in session
                let uid = user.uid
                let email = user.email
                let photoURL = user.photoURL
                
                // Connect to Database once logged in before segue
                ref = Database.database().reference()
                
                // Segue to the next view if User is signed in.
                self.performSegue(withIdentifier: "toAllProperties", sender: self)
            }
        } else {
            // No user is signed in.
            print("No USER FOUND")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // TODO: Sync from Userdefaults to Firebase.
    }
}

