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

class LoginController: UIViewController, GIDSignInUIDelegate {
    @IBOutlet weak var signInButtonByGoogle: GIDSignInButton!

//    @IBAction func signOutButton(_ sender: Any) {
//        print("Button being pressed")
//        let firebaseAuth = Auth.auth()
//        print("This: ",firebaseAuth)
//        do {
//            print("Signing Out")
//            try firebaseAuth.signOut()
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
//    }
    
//    @objc func nextVC() {
//        guard let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "register1") as? RegisterViewController1 else {
//            print("Could not instantiate view controller with identifier of type SecondViewController")
//            return
//        }
//        self.navigationController?.pushViewController(vc, animated:true)
//    }
    var handle: AuthStateDidChangeListenerHandle?
    //initializes the log in button
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()

        // TODO(developer) Configure the sign-in button look/feel
        // ...
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // [START auth_listener]
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
        }
        // [END auth_listener]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // [START remove_auth_listener]
        Auth.auth().removeStateDidChangeListener(handle!)
        // [END remove_auth_listener]
    }
}
