//
//  ListPropertiesTableViewCell.swift
//  RealEstate-Calculator
//
//  Created by timofey makhlay on 9/9/18.
//  Copyright © 2018 Timofey Makhlay. All rights reserved.
//
import Foundation
import UIKit


class ListPropertiesTableViewController: UITableViewController {
    var properties = [Property](){
        didSet {
            tableView.reloadData()
        }
    }
    
    // Not sure what this does but without it code won't work.
    @IBAction func unwindToListNotesViewController(segue: UIStoryboardSegue) {
        
        // for now, simply defining the method is sufficient.
        // we'll add code later
        
    }
    // TODO: https://www.makeschool.com/academy/track/learn-to-program-in-swift-and-get-started-creating-your-own-apps-and-games-DEM=/learn-how-to-build-make-school-notes--v2/intro-table-view-0VM=
    
    func unwrapDictionary(dictionary: [[String: [String: Double]]]) {
        for array in dictionary {
            for (name, dict) in array {
                let newProperty = Property()
                newProperty.name = name
                for (nameOfValue, value) in dict {
                    if nameOfValue == "price" {
                        newProperty.buyingPrice = value
                    } else if nameOfValue == "rent" {
                        newProperty.rent = value
                    }
                    else if nameOfValue == "buildingTax" {
                        newProperty.buildingTax = value
                    }
                    else if nameOfValue == "propertyTax" {
                        newProperty.propertyTax = value
                    }
                    else if nameOfValue == "fees" {
                        newProperty.yearlyFees = value
                    }
                    else if nameOfValue == "growth" {
                        newProperty.valueGrowth = value
                    }
                    print("Name: \(name) [\(nameOfValue): \(value)]")
                }
                properties.append(newProperty)
            }
        }
    }
    
    func deleteUserDefault(property: [String: [String: Double]]) {
        var dictionary = UserDefaults.standard.array(forKey: "properties") as! [[String : [String : Double]]]
        var count = 0
        for array in dictionary {
            for (name, dict) in array {
                for (propertyName, propertyValues) in property {
                    if name == propertyName && dict == propertyValues {
                        dictionary.remove(at: count)
                        UserDefaults.standard.set(dictionary,forKey: "properties")
                        UserDefaults.standard.synchronize()
                    }
                }
            }
            count += 1
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            // Deletes User Default Property
            deleteUserDefault(property: self.properties[indexPath.row].getDictionary())
            self.properties.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "displayProperty" {
                print("Table view cell tapped")
                // 1
                let indexPath = tableView.indexPathForSelectedRow!
                // 2
                let property = properties[indexPath.row]
                // 3
                let propertyInputController = segue.destination as! PropertyInputController
                // 4
                propertyInputController.property = property
            } else if segue.identifier == "addProperty" {
                print("+ button tapped")
            }
        }
    }
    
    // 1
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // 2
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return properties.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! ListPropertiesTableViewCell
        
        let row = indexPath.row
        
        let property = properties[row]
        
        
        // 2
        cell.propertyNameLabel.text = property.name
        cell.propertyWorthLabel.text = String(property.rent)
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // If the app has properties, this will add them. Otherwise, the page should remain empty
        if UserDefaults.standard.bool(forKey: "hasProperty") == true {
            unwrapDictionary(dictionary: UserDefaults.standard.array(forKey: "properties") as! [[String : [String : Double]]])
        }
    }
}
