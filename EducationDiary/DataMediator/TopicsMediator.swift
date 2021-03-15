//
//  TopicsMediator.swift
//  EducationDiary
//
//  Created by Eugene St on 01.02.2021.
//

import Foundation
import CoreData

class TopicsMediator: Mediator<Topics> {
    init() {
        super.init(.topics, pathForUpdate: .topicsUpdate)
    }
    
    // save to DB
    override func saveToDB(_ model: Topics) {
        model.forEach { (_, topic) in
            let topicCD = TopicCoreData(context: CoreDataManager.shared.context)
            topicCD.id = topic.id
            topicCD.title = topic.title
            topicCD.notes = topic.notes
            topicCD.status = topic.status
            topicCD.createdOn = topic.created_on ?? 0
            topicCD.dueDate = topic.due_date ?? 0
            topicCD.links = (topic.links ?? [""])
            
            var questionOnjectsArray: [Any] = []
            
            if let questions = topic.questions {
                
                questions.forEach { question in
                    let questionCD = QuestionCoreData(context: CoreDataManager.shared.context)
                    questionCD.answer = question.answer
                    questionCD.done = question.done ?? false
                    questionCD.id = question.id
                    questionCD.text = question.text
                    questionCD.topicID = question.topic_id
                    questionOnjectsArray.append(questionCD)
                }
                
                topicCD.questions = NSSet.init(array: questionOnjectsArray)
            }
            
            CoreDataManager.shared.saveItems()
        }
    }
    
    // fetch from DB
    override func fetchFromDB(_ completion: @escaping ResultClosure<Topics>) {
        
        CoreDataManager.shared.fetch(TopicCoreData.self) { result in
            switch result {
            
            case .success(let topicObjects):
                var topics: [String : Topic] = [:]
                
                topicObjects.forEach { topicObject in
                    var questions: [Question] = []
                    let questionsCD = topicObject.questions
                    
                    questionsCD?.forEach { questionCD in
                        let question = Question(
                            id: (questionCD as AnyObject).id,
                            topic_id: (questionCD as AnyObject).topicID,
                            text: (questionCD as AnyObject).text,
                            answer: (questionCD as AnyObject).answer,
                            done: (questionCD as AnyObject).done)
                        questions.append(question)
                    }
                    
                    topics[topicObject.id ?? ""] = Topic(
                        id: topicObject.id,
                        title: topicObject.title,
                        links: topicObject.links,
                        notes: topicObject.notes,
                        status: topicObject.status,
                        due_date: topicObject.dueDate,
                        created_on: topicObject.createdOn,
                        questions: questions
                    )
                }
                
                DispatchQueue.main.async {
                    completion(.success(topics))
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // delete single entity from db
    override func deleteFromDB(_ model: Model) {
        let request = CoreDataManager.shared.fetchRequest(TopicCoreData.self)
        
        do {
            let objects = try CoreDataManager.shared.context.fetch(request)
            
            objects.forEach { topicCD in
                if model.modelId == topicCD.id {
                    CoreDataManager.shared.deleteItem(topicCD)
                    CoreDataManager.shared.saveItems()
                }
            }
            
        } catch {
            print("Error deleting: \n \(error.localizedDescription)")
            Alert.errorAlert(error: error)
        }
    }
    
    // delete all entitied from DB
    override func deleteEntitiesFromDB() {
        CoreDataManager.shared.resetAllRecords(in: "TopicCoreData")
    }
    
    override func updateInDB(_ model: Model) {
        let request = CoreDataManager.shared.fetchRequest(TopicCoreData.self)
        let questionRequest = CoreDataManager.shared.fetchRequest(QuestionCoreData.self)
        
        do {
            let topicsCD = try CoreDataManager.shared.context.fetch(request)
            let questionsCD = try CoreDataManager.shared.context.fetch(questionRequest)
            
            topicsCD.forEach { topicCD in
                let topic = model as! Topic
                if model.modelId == topicCD.id {
                    topicCD.createdOn = topic.created_on ?? 0
                    topicCD.dueDate = topic.due_date ?? 0
                    topicCD.id = topic.id
                    topicCD.links = topic.links
                    topicCD.notes = topic.notes
                    topicCD.title = topic.title
                    topicCD.status = topic.status
                    
                    if let questions = topic.questions {
                        questions.forEach { question in
                            questionsCD.forEach { questionCD in
                                if question.modelId == questionCD.id {
                                    questionCD.answer = question.answer
                                    questionCD.done = question.done ?? false
                                    questionCD.text = question.text
                                    questionCD.id = question.id
                                    questionCD.topicID = question.topic_id
                                }
                            }
                        }
                    }
                    CoreDataManager.shared.saveItems()
                }
            }
            
        } catch {
            print("Error updating: \n \(error.localizedDescription)")
            Alert.errorAlert(error: error)
        }
    }
    
    override func createInDB(_ model: Model) {
        let topic = model as! Topic
        let topicCD = TopicCoreData(context: CoreDataManager.shared.context)
        
        topicCD.id = topic.id
        topicCD.title = topic.title
        topicCD.notes = topic.notes
        topicCD.status = topic.status
        topicCD.createdOn = topic.created_on ?? 0
        topicCD.dueDate = topic.due_date ?? 0
        topicCD.links = (topic.links ?? [""])
        
        let questionOnjectsArray: [Any] = []
        topicCD.questions = NSSet.init(array: questionOnjectsArray)
        CoreDataManager.shared.saveItems()
    }
}
