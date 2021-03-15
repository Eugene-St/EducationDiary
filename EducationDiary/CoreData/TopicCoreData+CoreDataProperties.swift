//
//  TopicCoreData+CoreDataProperties.swift
//  EducationDiary
//
//  Created by Eugene St on 12.03.2021.
//
//

import Foundation
import CoreData


extension TopicCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TopicCoreData> {
        return NSFetchRequest<TopicCoreData>(entityName: "TopicCoreData")
    }

    @NSManaged public var createdOn: Int32
    @NSManaged public var dueDate: Int32
    @NSManaged public var id: String?
    @NSManaged public var links: [String]?
    @NSManaged public var notes: String?
    @NSManaged public var status: String?
    @NSManaged public var title: String?
    @NSManaged public var questions: NSSet?

}

// MARK: Generated accessors for questions
extension TopicCoreData {

    @objc(addQuestionsObject:)
    @NSManaged public func addToQuestions(_ value: QuestionCoreData)

    @objc(removeQuestionsObject:)
    @NSManaged public func removeFromQuestions(_ value: QuestionCoreData)

    @objc(addQuestions:)
    @NSManaged public func addToQuestions(_ values: NSSet)

    @objc(removeQuestions:)
    @NSManaged public func removeFromQuestions(_ values: NSSet)

}

extension TopicCoreData : Identifiable {

}
