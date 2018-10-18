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

class LoginController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate  {
    // Connect to Firebase Database
    var ref: DatabaseReference!
    var uid: String?
    var username: String?
    var email: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGoogleButtons()
        // Connect Google Sign in from delegate and Sign in user.
        
        // TODO: Configure the sign-in button look/feel
    }
    fileprivate func setupGoogleButtons(){
        // add google sign in button
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        // automatically sign in the user.
        GIDSignIn.sharedInstance().signInSilently()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
    }
    //
    //    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
    //        // ...
    //        if let error = error {
    //            print("ERROR in SIGNIN")
    //            return
    //        }
    //        print("Sign IN WORKED")
    //        guard let authentication = user.authentication else { return }
    //        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
    //                                                       accessToken: authentication.accessToken)
    //        if Auth.auth().currentUser != nil {
    //            // User is signed in.
    //            let user = Auth.auth().currentUser
    //
    //            if let user = user {
    //                print("User found and Authenticated.")
    //                // Save user info in session
    //                uid = user.uid
    //                username = user.displayName
    //                email = user.email
    ////                let photoURL = user.photoURL
    //                print("email: ", email!)
    //
    //                // Connect to Database once logged in before segue
    ////                ref = Database.database().reference()
    //                // self.ref.child("users").child(user.uid).setValue(["username": username])
    //
    //                // Read saved Userdefaults and save/write into Firebase Database.
    ////                savePropertyArrayToFirebaseDatabase(userId: uid!, username: username!, dictionary: UserDefaults.standard.array(forKey: "properties") as! [[String : [String : Double]]])
    //
    //                // Segue to the next view if User is signed in.
    //                self.performSegue(withIdentifier: "toAllProperties", sender: self)
    //            }
    //        } else {
    //            // No user is signed in.
    //            print("No USER FOUND")
    //        }
    //    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print("Failed to login to Google")
            
            return
        }
        
        print("successfully logged into Google", user)
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print("Problem at signing in with google with error : \(error)")
                return
            }
            // User is signed in
            self.username = Auth.auth().currentUser?.displayName
            self.email = Auth.auth().currentUser?.email
            self.uid = Auth.auth().currentUser?.uid
            print("user successfully signed in through GOOGLE! uid:\(Auth.auth().currentUser!.email)")
            
            // Connect firebase database
            self.ref = Database.database().reference()
            
            // Testing if database works.
            //            self.ref.child("users").child(self.uid!).setValue(["username": self.username!])
            
            // Read saved Userdefaults and save/write into Firebase Database.
//            if UserDefaults.standard.array(forKey: "properties") != nil {
//                self.savePropertyArrayToFirebaseDatabase(userId: self.uid!, username: self.username!, dictionary: UserDefaults.standard.array(forKey: "properties") as! [[String : [String : Double]]])
//            }
            
            
            
            print("signed in")
            self.performSegue(withIdentifier: "toAllProperties", sender: self)
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // TODO: Sync from Userdefaults to Firebase.
        print("This is now working. SIGNOUT")
    }
    
    // Read saved Userdefaults and save/write into Firebase Database.
    func savePropertyArrayToFirebaseDatabase(userId: String, username: String, dictionary: [[String: [String: Double]]]) {
        
        if dictionary == nil {
            return
        }
        for array in dictionary {
            for (name, dict) in array {
                let newProperty = Property()
                newProperty.name = name
                self.ref.child("users/\(userId)/\(username)/property").setValue(name)
                for (nameOfValue, value) in dict {
                    if nameOfValue == "price" {
                        newProperty.buyingPrice = value
                        self.ref.child("users/\(userId)/\(username)/\(name)/nameOfvalue").setValue(nameOfValue)
                        self.ref.child("users/\(userId)/\(username)/\(name)/\(nameOfValue)/value").setValue(value)
                    } else if nameOfValue == "rent" {
                        newProperty.rent = value
                        self.ref.child("users/\(userId)/\(username)/\(name)/nameOfvalue").setValue(nameOfValue)
                        self.ref.child("users/\(userId)/\(username)/\(name)/\(nameOfValue)/value").setValue(value)
                    }
                    else if nameOfValue == "buildingTax" {
                        newProperty.buildingTax = value
                        self.ref.child("users/\(userId)/\(username)/\(name)/nameOfvalue").setValue(nameOfValue)
                        self.ref.child("users/\(userId)/\(username)/\(name)/\(nameOfValue)/value").setValue(value)
                    }
                    else if nameOfValue == "propertyTax" {
                        newProperty.propertyTax = value
                        self.ref.child("users/\(userId)/\(username)/\(name)/nameOfvalue").setValue(nameOfValue)
                        self.ref.child("users/\(userId)/\(username)/\(name)/\(nameOfValue)/value").setValue(value)
                    }
                    else if nameOfValue == "fees" {
                        newProperty.yearlyFees = value
                        self.ref.child("users/\(userId)/\(username)/\(name)/nameOfvalue").setValue(nameOfValue)
                        self.ref.child("users/\(userId)/\(username)/\(name)/\(nameOfValue)/value").setValue(value)
                    }
                    else if nameOfValue == "growth" {
                        newProperty.valueGrowth = value
                        self.ref.child("users/\(userId)/\(username)/\(name)/nameOfvalue").setValue(nameOfValue)
                        self.ref.child("users/\(userId)/\(username)/\(name)/\(nameOfValue)/value").setValue(value)
                    }
                    //                    print("Name: \(name) [\(nameOfValue): \(value)]")
                }
                //                properties.append(newProperty)
            }
        }
    }
    
    func appClosingSaveDataToFireBase() {
        print("I AM SAVING THE DATA TO DATABASE")
        // Read saved Userdefaults and save/write into Firebase Database.
//        if UserDefaults.standard.array(forKey: "properties") != nil {
//            LoginController.savePropertyArrayToFirebaseDatabase(userId: LoginController.uid!, username: LoginController.username!, dictionary: UserDefaults.standard.array(forKey: "properties") as! [[String : [String : Double]]])
//        }
    }
}

