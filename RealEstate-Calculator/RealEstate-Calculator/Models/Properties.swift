//
//  Properties.swift
//  RealEstate-Calculator
//
//  Created by timofey makhlay on 9/10/18.
//  Copyright © 2018 Timofey Makhlay. All rights reserved.
//

import Foundation
import RealmSwift

class Property: Object {
    @objc dynamic var propertyName = ""
    @objc dynamic var propertyRent: Double = 0.0
    @objc dynamic var propertyTax: Double = 0.0
}
