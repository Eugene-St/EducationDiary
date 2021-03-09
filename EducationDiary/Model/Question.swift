//
//  Question.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import Foundation



struct Question: Model {
    let id: String?
    let topic_id: String?
    let text: String?
    let answer: String?
    let done: Bool?
    
    var modelId: String {
        return id ?? ""
    }
}
