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
    let defaults = UserDefaults.standard
//    var testProperty = UserDefaults.standard.array(forKey: "properties")  as? [Property] ?? [Property]()

//    var appHasBeenClosed = UserDefaults.standard.bool(forKey: "closedApp")
    var properties = [Property](){
        didSet {
            tableView.reloadData()
        }
    }
    var propertyDict:[Int:Property] = [:]

    override func viewDidAppear(_ animated: Bool) {
//        defaults.set(properties, forKey: "properties")
//
//        let savingProperties =  properties
//        let encodedData = NSKeyedArchiver.archivedData(withRootObject: savingProperties)
//        defaults.set(encodedData, forKey: "properties")
        
//        let propertyDictionary = ["1":properties]
//        defaults.set(propertyDictionary, forKey: "property")
//        print(defaults.dictionary(forKey: "property") ?? [Int:Property]())
    }
    
    @IBAction func unwindToListNotesViewController(segue: UIStoryboardSegue) {
        
        // for now, simply defining the method is sufficient.
        // we'll add code later
        
    }
    // TODO: https://www.makeschool.com/academy/track/learn-to-program-in-swift-and-get-started-creating-your-own-apps-and-games-DEM=/learn-how-to-build-make-school-notes--v2/intro-table-view-0VM=
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
//        print("Has app been closed: ",appHasBeenClosed)
        //    if appHasBeenClosed == true {
        //        print()
        //    }
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
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
    }
}
