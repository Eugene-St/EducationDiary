//
//  Task.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import Foundation

typealias Tasks = [String : Task]

struct Task: Codable {
    let created_on: Float?
    let description, id: String?
    let progress: Float?
}
