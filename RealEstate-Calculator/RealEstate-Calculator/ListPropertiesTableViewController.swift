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
    
    
    // TODO: https://www.makeschool.com/academy/track/learn-to-program-in-swift-and-get-started-creating-your-own-apps-and-games-DEM=/learn-how-to-build-make-school-notes--v2/intro-table-view-0VM=
    
    // 1
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    // 2
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        cell.textLabel?.text = "Yay it's working"
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
