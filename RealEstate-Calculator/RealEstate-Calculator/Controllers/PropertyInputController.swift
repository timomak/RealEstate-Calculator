//
//  ViewController.swift
//  RealEstate-Calculator
//
//  Created by timofey makhlay on 9/9/18.
//  Copyright © 2018 Timofey Makhlay. All rights reserved.
//

import UIKit
import RealmSwift

class PropertyInputController: UIViewController {
//    var properties = [Property]()
    var property: Property?
    var properties: Results<Property>!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var rentTextField: UITextField!
    @IBOutlet weak var taxTextField: UITextField!
    
    
    @IBOutlet weak var totalIncomeTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let property = property {
            // 2
            nameTextField.text = property.propertyName
            rentTextField.text = String(property.propertyRent)
            taxTextField.text = String(property.propertyTax)
        } else {
            // 3
            nameTextField.text = ""
            rentTextField.text = ""
            taxTextField.text = ""
        }
    }
    
    
    @IBAction func calculateVariables(_ sender: Any) {
        if let rentIncome = Double(rentTextField.text!) {
            let rentTax = Double(taxTextField.text!)
            
            let totalIncomeMath = (rentIncome * 12) - (rentTax! * 12)
            totalIncomeTextField.text = String(format: "%.2f", totalIncomeMath)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let listPropertiesTableViewController = segue.destination as! ListPropertiesTableViewController
        if segue.identifier == "Save" {
            print("Save button tapped")
            
            
            if let property = property {
                let newProperty = Property()
                newProperty.propertyName = nameTextField.text ?? ""
                newProperty.propertyRent = Double(rentTextField.text!)!
                newProperty.propertyTax = Double(taxTextField.text!)!
                
                RealmHelper.updateProperty(propertyToBeUpdated: property, newProperty: newProperty)
            } else {
                
            let property = Property()
                property.propertyName = nameTextField.text ?? ""
                property.propertyRent = Double(rentTextField.text!)!
                property.propertyTax = Double(taxTextField.text!)!
                RealmHelper.addProperty(property: property)
            }
            
            listPropertiesTableViewController.properties = RealmHelper.retrieveProperty()
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        RealmHelper.retrieveProperty()
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
