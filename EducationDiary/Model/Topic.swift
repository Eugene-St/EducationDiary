//
//  Topic.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import Foundation

typealias Topics = [String : TopicProperties]

struct TopicProperties: Codable {
    let id: String?
    let title: String?
    let links: [String]?
    let notes: String?
    let status: String?
    let due_date: Float?
    let created_on: Float?
    let questions: [Question]?
}