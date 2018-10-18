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
            if UserDefaults.standard.array(forKey: "properties") != nil {
                self.savePropertyArrayToFirebaseDatabase(userId: self.uid!, username: self.username!, dictionary: UserDefaults.standard.array(forKey: "properties") as! [[String : [String : Double]]])
            }
            
            
            
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
        // Look through each array in the array named "dictionary"
        for array in dictionary {
            
            // Break down dictionaries within the array
            for (name, dict) in array {
                // Create a new property
                let newProperty = Property()
                // Set property name
                newProperty.name = name
                
                print("Property name: ", Database.database().reference().child("users/\(userId)/\(username)/property"))
                // Save name in Firebase Database
                Database.database().reference().child("users/\(userId)/\(username)/property").setValue(name)
                
                // Break down dictionaries within dictionary.
                for (nameOfValue, value) in dict {
                    if nameOfValue == "price" {
                        newProperty.buyingPrice = value
                        print("Price: ", value)
                        Database.database().reference().child("users/\(userId)/\(username)/\(name)/nameOfvalue").setValue(nameOfValue)
                        Database.database().reference().child("users/\(userId)/\(username)/\(name)/\(nameOfValue)/value").setValue(value)
                    } else if nameOfValue == "rent" {
                        newProperty.rent = value
                        Database.database().reference().child("users/\(userId)/\(username)/\(name)/nameOfvalue").setValue(nameOfValue)
                        Database.database().reference().child("users/\(userId)/\(username)/\(name)/\(nameOfValue)/value").setValue(value)
                    }
                    else if nameOfValue == "buildingTax" {
                        newProperty.buildingTax = value
                        Database.database().reference().child("users/\(userId)/\(username)/\(name)/nameOfvalue").setValue(nameOfValue)
                        Database.database().reference().child("users/\(userId)/\(username)/\(name)/\(nameOfValue)/value").setValue(value)
                    }
                    else if nameOfValue == "propertyTax" {
                        newProperty.propertyTax = value
                        Database.database().reference().child("users/\(userId)/\(username)/\(name)/nameOfvalue").setValue(nameOfValue)
                        Database.database().reference().child("users/\(userId)/\(username)/\(name)/\(nameOfValue)/value").setValue(value)
                    }
                    else if nameOfValue == "fees" {
                        newProperty.yearlyFees = value
                        Database.database().reference().child("users/\(userId)/\(username)/\(name)/nameOfvalue").setValue(nameOfValue)
                        Database.database().reference().child("users/\(userId)/\(username)/\(name)/\(nameOfValue)/value").setValue(value)
                    }
                    else if nameOfValue == "growth" {
                        newProperty.valueGrowth = value
                        Database.database().reference().child("users/\(userId)/\(username)/\(name)/nameOfvalue").setValue(nameOfValue)
                        Database.database().reference().child("users/\(userId)/\(username)/\(name)/\(nameOfValue)/value").setValue(value)
                    }
                    //                    print("Name: \(name) [\(nameOfValue): \(value)]")
                }
                //                properties.append(newProperty)
            }
        }
    }
    
    
    // Save/Write properties saved with userdefaults into Firebase Database as one array.
    func fukIt(userId: String, username: String, dictionary: [[String: [String: Double]]]) {
        
        if dictionary == nil {
            return
        }
        // Saving to Database
            Database.database().reference().child("users/\(userId)/\(username)/properties").setValue(dictionary)
            
            print("Properties: ", dictionary)
    }
    
    func appClosingSaveDataToFireBase() {
        print("I AM SAVING THE DATA TO DATABASE")
        let usernameSave = Auth.auth().currentUser?.displayName
        print("Login Username: ", usernameSave!)
        let userUID = Auth.auth().currentUser?.uid
        print("User ID: ", userUID!)

        // Saving Data to Firebase database before closing app.
        fukIt(userId: userUID!, username: usernameSave!, dictionary: UserDefaults.standard.array(forKey: "properties") as! [[String : [String : Double]]])

    }
}

