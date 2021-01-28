//
//  DataManager.swift
//  DreamCars
//
//  Created by Eugene St on 25.01.2021.
//

import UIKit
import CoreData

struct DataManager {
    
    static let shared = DataManager()
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    func saveData(_ value: Bool, key: String) {
        defaults.set(value, forKey: key)
    }
    
    func fetchBool(key: String) -> Bool {
        return defaults.bool(forKey: key)
    }
    
    func getDataFromFile(context: NSManagedObjectContext) {
        
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "mark != nil")
        
        var records = 0
        
        do {
            records = try context.count(for: fetchRequest)
            print("Data loaded")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        guard records == 0 else { return }
        
        print("records - \(records) Data loaded")
        guard let filePath = Bundle.main.path(forResource: "data", ofType: "plist"),
              let dataArray = NSArray(contentsOfFile: filePath) else { return }
        
        dataArray.forEach { dictionary in
            
            guard let entity = NSEntityDescription.entity(forEntityName: "Car", in: context) else { return }
            //            let car = NSManagedObject(entity: entity, insertInto: context) as! Car
            let car = Car(entity: entity, insertInto: context)
            
            let carDictionary = dictionary as! [String: AnyObject]
            
            car.mark = carDictionary["mark"] as? String
            car.model = carDictionary["model"] as? String
            car.rating = carDictionary["rating"] as! Double
            car.lastStarted = carDictionary["lastStarted"] as? Date
            car.timesDriven = carDictionary["timesDriven"] as! Int16
            car.myChoice = carDictionary["myChoice"] as! Bool
            
            guard let imageName = carDictionary["imageName"] as? String else { return }
            let image = UIImage(named: imageName)
            let imageData = image?.pngData()
            car.imageData = imageData
            
            if let colorDictionary = carDictionary["tintColor"] as? [String: Float] {
                car.tintColor = getColor(colorDictionary: colorDictionary)
            }
        }
    }
    
    private func getColor(colorDictionary: [String: Float]) -> UIColor {
        
        guard let red = colorDictionary["red"],
              let green = colorDictionary["green"],
              let blue = colorDictionary["blue"] else { return .darkGray }
        
        return UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1.0)
    }
}
