//
//  ListPropertiesTableViewCell.swift
//  RealEstate-Calculator
//
//  Created by timofey makhlay on 9/9/18.
//  Copyright © 2018 Timofey Makhlay. All rights reserved.
//
import Foundation
import UIKit

struct Headline {
    
    var id : Int
    var title : String
    var text : String
    var image : String
    
}

class ListPropertiesTableViewController: UITableViewController {
    
    @IBAction func unwindToListNotesViewController(segue: UIStoryboardSegue) {
        
        // for now, simply defining the method is sufficient.
        // we'll add code later
        
    }
    // TODO: https://www.makeschool.com/academy/track/learn-to-program-in-swift-and-get-started-creating-your-own-apps-and-games-DEM=/learn-how-to-build-make-school-notes--v2/intro-table-view-0VM=
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        
        
        if let identifier = segue.identifier {
            print("Identifier: ",identifier)
            if identifier == "displayProperty" {
                print("Table view cell tapped")
            } else if segue.identifier == "addProperty" {
                print("+ button tapped")
            } else {
                print("Identifier: ",identifier)
            }
        }
    }
    
    // 1
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    // 2
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
//
//        cell.textLabel?.text = "Yay it's working"
//
//        return cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! ListPropertiesTableViewCell
        
        // 2
        cell.propertyNameLabel.text = "Property Name"
        cell.propertyWorthLabel.text = "Property Worth"
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
