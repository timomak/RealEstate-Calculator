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
import FirebaseDatabase

// TODO: Handle UserDefualts sync from Firebase to Userdefaults after Login

class LoginController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate  {
    // Connect to Firebase Database
    var ref: DatabaseReference!
    // Handle the data from database
    var dataHandle: DatabaseHandle?
    
    var dataProperties = [Any]()
    
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
            
            // Create new properties with the firebase database
            let query = Database.database().reference().child("users").child(self.uid!).queryOrderedByPriority()
            query.observe(.value, with: { snapshot in
                for child in snapshot.children {
                    let properties = child as! DataSnapshot
                    for property in properties.children {
                        var count = 0
                        let allPropertiesName = property as! DataSnapshot
                        for propertyName in allPropertiesName.children {
                            let propertyNameValue = propertyName as! DataSnapshot
                            print("Property name \(count): ", propertyNameValue.value as! [String:Any])
                            count += 1
                        }
                    }
                    
                    
//                    let snap = child as! DataSnapshot
//                    let key = snap.key
//                    let value = snap.value as? [Any]
//                    self.dataProperties.append(value!)
//                    print("key = \(key)  value = \(value!)")
//                    print("Properties Data: ", self.dataProperties)
                    
                    
                }
            })
            
            // Move to property list
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
        print("SAVING DATA IN FIREBASE WITHIN fukIt().")
        if dictionary == nil {
            return
        }
        // Saving to Database
        Database.database().reference().child("users").child(userId).child("properties").setValue(dictionary)
        
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
        print("fukIt finished!")
        
    }
}

