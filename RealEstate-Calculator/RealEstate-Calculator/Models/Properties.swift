//
//  Properties.swift
//  RealEstate-Calculator
//
//  Created by timofey makhlay on 9/10/18.
//  Copyright © 2018 Timofey Makhlay. All rights reserved.
//

// TODO: User questionaire to find out how much tax they have to pay.
// TODO: Delete from database

import UIKit

class Property {
    var name = "Item 1"
    var buyingPrice: Double = 0.0
    var rent: Double = 0.0
    var buildingTax: Double = 0.0
    var propertyTax: Double = 0.0
    var yearlyFees: Double = 0.0
    var valueGrowth: Double = 0.0
    
    // Function to return property in JSON format to be able to store it with UserDefaults
    func getDictionary() -> [String: [String: Double]] {
        return [name: ["price": buyingPrice, "rent": rent, "buildingTax": buildingTax, "propertyTax": propertyTax, "fees":yearlyFees, "growth": valueGrowth]]
    }
}
