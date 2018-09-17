//
//  RealmHelper.swift
//  RealEstate-Calculator
//
//  Created by timofey makhlay on 9/13/18.
//  Copyright © 2018 Timofey Makhlay. All rights reserved.
//

import RealmSwift

class RealmHelper {
//    static methods will go here.
    static func addProperty(property: Property) {
        let realm = try! Realm()
        try! realm.write() {
            realm.add(property)
        }
    }
    static func deleteProperty(property: Property) {
        let realm = try! Realm()
        try! realm.write() {
            realm.delete(property)
        }
    }
    static func updateProperty(propertyToBeUpdated: Property, newProperty: Property) {
        let realm = try! Realm()
        try! realm.write() {
            propertyToBeUpdated.propertyName = newProperty.propertyName
            propertyToBeUpdated.propertyRent = newProperty.propertyRent
            propertyToBeUpdated.propertyTax = newProperty.propertyTax
        }
    }
    static func retrieveProperty() -> Results<Property> {
        let realm = try! Realm()
        return realm.objects(Property.self).sorted(byKeyPath: "propertyRent", ascending: false)
    }
    static func countProperties() -> Int {
        let realm = try! Realm()
        return realm.objects(Property.self).count
    }
}
