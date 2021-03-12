//
//  QuestionCoreData+CoreDataProperties.swift
//  EducationDiary
//
//  Created by Eugene St on 12.03.2021.
//
//

import Foundation
import CoreData


extension QuestionCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuestionCoreData> {
        return NSFetchRequest<QuestionCoreData>(entityName: "QuestionCoreData")
    }

    @NSManaged public var answer: String?
    @NSManaged public var done: Bool
    @NSManaged public var id: String?
    @NSManaged public var text: String?
    @NSManaged public var topicID: String?
    @NSManaged public var topic: TopicCoreData?

}

extension QuestionCoreData : Identifiable {

}
