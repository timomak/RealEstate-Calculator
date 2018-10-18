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
//    var ref: DatabaseReference!
    @IBOutlet weak var signInButtonByGoogle: GIDSignInButton!
    var uid: String?
    var username: String?
    var email: String?
    
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
            print("ERROR in SIGNIN")
            return
        }
        print("Sign IN WORKED")
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        if Auth.auth().currentUser != nil {
            // User is signed in.
            let user = Auth.auth().currentUser
            
            if let user = user {
                print("User found and Authenticated.")
                // Save user info in session
                uid = user.uid
                username = user.displayName
                email = user.email
//                let photoURL = user.photoURL
                print("email: ", email!)
                
                // Connect to Database once logged in before segue
//                ref = Database.database().reference()
                // self.ref.child("users").child(user.uid).setValue(["username": username])
                
                // Read saved Userdefaults and save/write into Firebase Database.
//                savePropertyArrayToFirebaseDatabase(userId: uid!, username: username!, dictionary: UserDefaults.standard.array(forKey: "properties") as! [[String : [String : Double]]])
                
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
        print("This is now working. SIGNOUT")
    }
    
//    // Read saved Userdefaults and save/write into Firebase Database.
//    func savePropertyArrayToFirebaseDatabase(reference: DatabaseReference, userId: String, username: String, dictionary: [[String: [String: Double]]]) {
//        for array in dictionary {
//            for (name, dict) in array {
//                let newProperty = Property()
//                newProperty.name = name
//                reference.child("users/\(userId)/\(username)/property").setValue(name)
//                for (nameOfValue, value) in dict {
//                    if nameOfValue == "price" {
//                        newProperty.buyingPrice = value
//                        reference.child("users/\(userId)/\(username)/\(name)/nameOfvalue").setValue(nameOfValue)
//                        reference.child("users/\(userId)/\(username)/\(name)/\(nameOfValue)/value").setValue(value)
//                    } else if nameOfValue == "rent" {
//                        newProperty.rent = value
//                        reference.child("users/\(userId)/\(username)/\(name)/nameOfvalue").setValue(nameOfValue)
//                        reference.child("users/\(userId)/\(username)/\(name)/\(nameOfValue)/value").setValue(value)
//                    }
//                    else if nameOfValue == "buildingTax" {
//                        newProperty.buildingTax = value
//                        reference.child("users/\(userId)/\(username)/\(name)/nameOfvalue").setValue(nameOfValue)
//                        reference.child("users/\(userId)/\(username)/\(name)/\(nameOfValue)/value").setValue(value)
//                    }
//                    else if nameOfValue == "propertyTax" {
//                        newProperty.propertyTax = value
//                        reference.child("users/\(userId)/\(username)/\(name)/nameOfvalue").setValue(nameOfValue)
//                        reference.child("users/\(userId)/\(username)/\(name)/\(nameOfValue)/value").setValue(value)
//                    }
//                    else if nameOfValue == "fees" {
//                        newProperty.yearlyFees = value
//                        reference.child("users/\(userId)/\(username)/\(name)/nameOfvalue").setValue(nameOfValue)
//                        reference.child("users/\(userId)/\(username)/\(name)/\(nameOfValue)/value").setValue(value)
//                    }
//                    else if nameOfValue == "growth" {
//                        newProperty.valueGrowth = value
//                        reference.child("users/\(userId)/\(username)/\(name)/nameOfvalue").setValue(nameOfValue)
//                        reference.child("users/\(userId)/\(username)/\(name)/\(nameOfValue)/value").setValue(value)
//                    }
////                    print("Name: \(name) [\(nameOfValue): \(value)]")
//                }
//                //                properties.append(newProperty)
//            }
//        }
//    }
//
//    func appClosingSaveDataToFireBase() {
//        print("I AM SAVING THE DATA TO DATABASE")
//        savePropertyArrayToFirebaseDatabase(reference: ref!, userId: uid!, username: username!, dictionary: UserDefaults.standard.array(forKey: "properties") as! [[String : [String : Double]]])
//    }
}

