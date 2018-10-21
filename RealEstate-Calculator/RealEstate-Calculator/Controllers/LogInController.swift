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
    
    var dataProperties: [[String:[String:Double]]] = []
    
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
            self.saveLocallyTheDataFromFirebase()
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
    func sendAllPropertiesToFirebaseDatabase(userId: String, username: String, dictionary: [[String: [String: Double]]]) {
        print("SAVING DATA IN FIREBASE WITHIN sendAllPropertiesToFirebaseDatabase().")
        // Saving to Database
        Database.database().reference().child("users").child(userId).child("properties").setValue(dictionary)
        print("Properties: ", dictionary)
    }
    
    func appClosingSaveDataToFireBase() {
        print("I AM SAVING THE DATA TO DATABASE")
        let usernameSave = Auth.auth().currentUser?.displayName
        let userUID = Auth.auth().currentUser?.uid
        
        // Saving Data to Firebase database before closing app.
        sendAllPropertiesToFirebaseDatabase(userId: userUID!, username: usernameSave!, dictionary: UserDefaults.standard.array(forKey: "properties") as! [[String : [String : Double]]])
        print("sendAllPropertiesToFirebaseDatabase() finished!")
        
    }
    
    func saveLocallyTheDataFromFirebase() {
        let usernameSave = Auth.auth().currentUser?.displayName
        let userUID = Auth.auth().currentUser?.uid
        print("Setting query Path and saving firebase data Locally")
        // Create new properties with the firebase database
        // Add a path to the data using the user info
        let query = Database.database().reference().child("users").child(userUID!).child("properties").queryOrderedByPriority()
        
                
        // Using the path, find the user data.
        query.observe(.value, with: { snapshot in
            // If there is data already, make the data into an array and save it as userdefaults.
            if let snapshotValue = snapshot.value as? [[String:[String:Double]]] {
//                print("The super cool, super array works!")
//                print("Snapshot value as super array: ", snapshotValue)
                self.dataProperties = snapshotValue
//                print("dataProperties value as super array: ", self.dataProperties)
                UserDefaults.standard.set(self.dataProperties, forKey: "properties")
                // Making sure that the rest of the app knows that there are properties already in the app.
                UserDefaults.standard.set(true, forKey: "hasProperty")
                UserDefaults.standard.synchronize()
//                print("New Data saved: ", UserDefaults.standard.array(forKey: "properties") as! [[String : [String : Double]]])
            }
        })
    }
    
    func addNewPropertyInFirebaseDatabaseAndLocally(array:[String : [String : Double]]) {
        print("Adding new Property to firebase database")
        print("Property: ", array)
        let usernameSave = Auth.auth().currentUser?.displayName
        let userUID = Auth.auth().currentUser?.uid
        
        // Get properties from database to the app
        saveLocallyTheDataFromFirebase()
        
        // Setting local variable to saved database properties array
        dataProperties = UserDefaults.standard.array(forKey: "properties") as! [[String : [String : Double]]]
        print("Data Properties before Adding new property: ", dataProperties)
        
        // Add new properties
        dataProperties.append(array)
        print("Data Properties after Adding new property: ", dataProperties)
        UserDefaults.standard.set(dataProperties, forKey: "properties")
        UserDefaults.standard.synchronize()
        
        // Upload the new list of properties
        sendAllPropertiesToFirebaseDatabase(userId: userUID!, username: usernameSave!, dictionary: dataProperties)
    }
    
    func removeProperyInFirebaseDatabaseAndLocally(removeAt: Int, array:[String : [String : Double]]) {
        print("Removing Property from firebase database")
        print("Property: ", array)
        let usernameSave = Auth.auth().currentUser?.displayName
        let userUID = Auth.auth().currentUser?.uid
        
        // Get properties from database to the app
        saveLocallyTheDataFromFirebase()
        
        // Setting local variable to saved database properties array
        dataProperties = UserDefaults.standard.array(forKey: "properties") as! [[String : [String : Double]]]
        
        // Remove the property
        dataProperties.remove(at: removeAt)
        UserDefaults.standard.set(dataProperties, forKey: "properties")
        UserDefaults.standard.synchronize()
        
        // Upload the new list of properties
        sendAllPropertiesToFirebaseDatabase(userId: userUID!, username: usernameSave!, dictionary: dataProperties)
    }
}

