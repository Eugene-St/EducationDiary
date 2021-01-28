//
//  Car+CoreDataProperties.swift
//  DreamCars
//
//  Created by Eugene St on 25.01.2021.
//
//

import Foundation
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var imageData: Data?
    @NSManaged public var lastStarted: Date?
    @NSManaged public var rating: Double
    @NSManaged public var mark: String?
    @NSManaged public var model: String?
    @NSManaged public var timesDriven: Int16
    @NSManaged public var myChoice: Bool
    @NSManaged public var tintColor: NSObject?

}

extension Car : Identifiable {

}
