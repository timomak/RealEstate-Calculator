//
//  ViewController.swift
//  RealEstate-Calculator
//
//  Created by timofey makhlay on 9/9/18.
//  Copyright © 2018 Timofey Makhlay. All rights reserved.
//


import UIKit

class PropertyInputController: UIViewController {
    var property: Property?
    var selectedRow: Int?
    // User has to input these items.
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var buyingPriceTextField: UITextField!
    @IBOutlet weak var rentTextField: UITextField!
    @IBOutlet weak var buildingTaxTextField: UITextField!
    @IBOutlet weak var propertyTaxTextField: UITextField!
    @IBOutlet weak var yearlyFeesTextField: UITextField!
    @IBOutlet weak var valueGrowthTextField: UITextField!
    @IBOutlet weak var squaredFeetTextField: UITextField!
    
    // App will calculate.
    @IBOutlet weak var pricePerSquareFoot: UITextField!
    @IBOutlet weak var totalTaxTextField: UITextField!
    @IBOutlet weak var afterTaxAndFeesIncomeYearlyTextField: UITextField!
    @IBOutlet weak var afterTaxAndFeesIncomeMonthlyTextField: UITextField!
    @IBOutlet weak var incomeYearlyBeforeTaxTextField: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        calculateVariables()
    }
    
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
            squaredFeetTextField.text = String(property.squaredFeet)
        } else {
            // Else if the property is new, the values will be empty.
            nameTextField.text = ""
            buyingPriceTextField.text = ""
            rentTextField.text = ""
            buildingTaxTextField.text = ""
            propertyTaxTextField.text = ""
            yearlyFeesTextField.text = ""
            valueGrowthTextField.text = ""
            squaredFeetTextField.text = ""
        }
    }
    
    func calculateVariables() {
        print("Calculating function running.")
        // Calculating Building tax.
        if let buildingTax = Double(buildingTaxTextField.text!), let propertyTax = Double(propertyTaxTextField.text!), let rent = Double(rentTextField.text!), let buyingPrice = Double(buyingPriceTextField.text!), let squareFeet = Double(squaredFeetTextField.text!) {
            
            
            let costPerSquareFoot = buyingPrice / squareFeet
            pricePerSquareFoot.text = String(format: "%.2f", costPerSquareFoot)
            
            // Yearly Tax
            let totalTax = buildingTax + propertyTax
            totalTaxTextField.text = String(format: "%.2f", totalTax)
            
            // Yearly Rent income
            let rentTaxMonthly = buildingTax + propertyTax
            let totalRentPositive = (rent - rentTaxMonthly) * 12.00
            afterTaxAndFeesIncomeYearlyTextField.text = String(format: "%.2f", totalRentPositive)
            
            // Monthly Rent Income
            let totalRentMonthly = (rent - rentTaxMonthly)
            afterTaxAndFeesIncomeMonthlyTextField.text = String(format: "%.2f", totalRentMonthly)
            
            // Total Income
            let totalIncome = (rent) * 12.00
            incomeYearlyBeforeTaxTextField.text = String(format: "%.2f", totalIncome)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        calculateVariables()
        let listPropertiesTableViewController = segue.destination as! ListPropertiesTableViewController
        let logInController = LoginController()
        if segue.identifier == "Save" {
            print("Save button tapped")
            // If the property already exists, input the existing values.
            if let editedProperty = property {
                editedProperty.name = nameTextField.text ?? ""
                editedProperty.buyingPrice = Double(buyingPriceTextField.text!)!
                editedProperty.rent = Double(rentTextField.text!)!
                editedProperty.buildingTax = Double(buildingTaxTextField.text!)!
                editedProperty.propertyTax = Double(propertyTaxTextField.text!)!
                editedProperty.yearlyFees = Double(yearlyFeesTextField.text!)!
                editedProperty.valueGrowth = Double(valueGrowthTextField.text!)!
                editedProperty.squaredFeet = Double(squaredFeetTextField.text!)!

                logInController.updateProperyInFirebaseDatabaseAndLocally(updateAt: selectedRow!, array: editedProperty.getDictionary())
                listPropertiesTableViewController.tableView.reloadData()
            }
            // Else update the already existing property.
           else {
                let newProperty = Property()
                newProperty.name = nameTextField.text ?? "no name"
                newProperty.buyingPrice = Double(buyingPriceTextField.text ?? "0") ?? 0.00
                newProperty.rent = Double(rentTextField.text ?? "0") ?? 0.00
                newProperty.buildingTax = Double(buildingTaxTextField.text ?? "0") ?? 0.00
                newProperty.propertyTax = Double(propertyTaxTextField.text ?? "0") ?? 0.00
                newProperty.yearlyFees = Double(yearlyFeesTextField.text ?? "0") ?? 0.00
                newProperty.valueGrowth = Double(valueGrowthTextField.text ?? "0") ?? 0.00
                newProperty.squaredFeet = Double(squaredFeetTextField.text ?? "0") ?? 0.00
                
                // Get the values of the new property from class method.
                // Add the new property to UserDefaults
                logInController.addNewPropertyInFirebaseDatabaseAndLocally(array: newProperty.getDictionary())
                // Add property to properties to be displayed in the first view.
                listPropertiesTableViewController.properties.append(newProperty)
                
                // Notify that the app has properties.
                UserDefaults.standard.set(true, forKey: "hasProperty")
                UserDefaults.standard.synchronize()
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
    // Hide the keyboard when tapped away from it.
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
