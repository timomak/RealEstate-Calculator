//
//  Properties.swift
//  RealEstate-Calculator
//
//  Created by timofey makhlay on 9/10/18.
//  Copyright © 2018 Timofey Makhlay. All rights reserved.
//

// TODO: User questionaire to find out how much tax they have to pay.

import UIKit

class Property {
    // MARK: Change this once added UserDefaults
    var numberOfProperties = 0
    
    var name : String
    var buyingPrice: Double
    var rent: Double
    var buildingTax: Double
    var propertyTax: Double
    var yearlyFees: Double
    var valueGrowth: Double
    
    init(Name: String, Price: Double, Rent: Double, BuildingTax: Double, PropertyTax: Double, YearlyFees: Double, ValueGrowth: Double) {
        self.name = Name
        self.buyingPrice = Price
        self.rent = Rent
        self.buildingTax = BuildingTax
        self.propertyTax = PropertyTax
        self.yearlyFees = YearlyFees
        self.valueGrowth = ValueGrowth
    }
    
    func savePropertyData(_ property: Property) {
        UserDefaults.standard.set(property, forKey: String(numberOfProperties))
    }
}
