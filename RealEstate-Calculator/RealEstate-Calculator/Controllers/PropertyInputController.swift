//
//  ViewController.swift
//  RealEstate-Calculator
//
//  Created by timofey makhlay on 9/9/18.
//  Copyright © 2018 Timofey Makhlay. All rights reserved.
//


import UIKit

class PropertyInputController: UIViewController {
//    var properties = [Property]()
    var property: Property?
    // User has to input these items.
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var buyingPriceTextField: UITextField!
    @IBOutlet weak var rentTextField: UITextField!
    @IBOutlet weak var buildingTaxTextField: UITextField!
    @IBOutlet weak var propertyTaxTextField: UITextField!
    @IBOutlet weak var yearlyFeesTextField: UITextField!
    @IBOutlet weak var valueGrowthTextField: UITextField!
    
    // App will calculate.
    @IBOutlet weak var totalTaxTextField: UITextField!
    @IBOutlet weak var afterTaxAndFeesIncomeYearlyTextField: UITextField!
    @IBOutlet weak var afterTaxAndFeesIncomeMonthlyTextField: UITextField!
    @IBOutlet weak var incomeYearlyBeforeTaxTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        // What the User Sees when he opens the Property Input Page.
        super.viewWillAppear(animated)
        // Calculating everything the user doesn't have to input.
        calculateVariables()
        
        if let property = property {
            // If the Property already exists, it will load its values.
            nameTextField.text = property.name
            buyingPriceTextField.text = String(property.buyingPrice)
            rentTextField.text = String(property.rent)
            buildingTaxTextField.text = String(property.buildingTax)
            propertyTaxTextField.text = String(property.propertyTax)
            yearlyFeesTextField.text = String(property.yearlyFees)
            valueGrowthTextField.text = String(property.valueGrowth)
        } else {
            // Else if the property is new, the values will be empty.
            nameTextField.text = ""
            buyingPriceTextField.text = ""
            rentTextField.text = ""
            buildingTaxTextField.text = ""
            propertyTaxTextField.text = ""
            yearlyFeesTextField.text = ""
            valueGrowthTextField.text = ""
        }
    }
    
    func calculateVariables() {
        print("Calculating function running.")
        // Calculating Building tax.
        if let buildingTax = Double(buildingTaxTextField.text!), let propertyTax = Double(propertyTaxTextField.text!) {
            let totalTax = buildingTax + propertyTax
            totalTaxTextField.text = String(format: "%.2f", totalTax)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        calculateVariables()
        let listPropertiesTableViewController = segue.destination as! ListPropertiesTableViewController
        if segue.identifier == "Save" {
            print("Save button tapped")
            print("property: ", Property())
            
            if let property = property {
                property.name = nameTextField.text ?? ""
                property.buyingPrice = Double(buyingPriceTextField.text!)!
                property.rent = Double(rentTextField.text!)!
                property.buildingTax = Double(buildingTaxTextField.text!)!
                property.propertyTax = Double(propertyTaxTextField.text!)!
                property.yearlyFees = Double(yearlyFeesTextField.text!)!
                property.valueGrowth = Double(valueGrowthTextField.text!)!
                listPropertiesTableViewController.tableView.reloadData()
            } else {
                let newProperty = Property()
                newProperty.name = nameTextField.text ?? ""
                newProperty.buyingPrice = Double(buyingPriceTextField.text!)!
                newProperty.rent = Double(rentTextField.text!)!
                newProperty.buildingTax = Double(buildingTaxTextField.text!)!
                newProperty.propertyTax = Double(propertyTaxTextField.text!)!
                newProperty.yearlyFees = Double(yearlyFeesTextField.text!)!
                newProperty.valueGrowth = Double(valueGrowthTextField.text!)!
                
                listPropertiesTableViewController.properties.append(newProperty)
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        calculateVariables()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.hideKeyboardWhenTappedAround()
        calculateVariables()
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
