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
        super.viewWillAppear(animated)

        if let property = property {
            // 2
            nameTextField.text = property.name
            buyingPriceTextField.text = String(property.buyingPrice)
            rentTextField.text = String(property.rent)
            buildingTaxTextField.text = String(property.buildingTax)
            propertyTaxTextField.text = String(property.propertyTax)
            yearlyFeesTextField.text = String(property.yearlyFees)
            valueGrowthTextField.text = String(property.valueGrowth)
            
        } else {
            // 3
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
        print("calculating")
        if let buildingTax = Double(buildingTaxTextField.text!), let propertyTax = Double(propertyTaxTextField.text!) {
            let totalRent = buildingTax + propertyTax
            totalTaxTextField.text = String(format: "%.2f", totalRent)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let listPropertiesTableViewController = segue.destination as! ListPropertiesTableViewController
        if segue.identifier == "Save" {
            print("Save button tapped")
            
            
            if let property = property {
                property.propertyName = nameTextField.text ?? ""
                property.propertyRent = Double(rentTextField.text!)!
                property.propertyTax = Double(taxTextField.text!)!
                listPropertiesTableViewController.tableView.reloadData()
            } else {
                let newProperty = Property()
                newProperty.propertyName = nameTextField.text ?? ""
                newProperty.propertyRent = Double(rentTextField.text!)!
                newProperty.propertyTax = Double(taxTextField.text!)!
                
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
