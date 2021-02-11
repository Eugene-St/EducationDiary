//
//  Task.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import Foundation

typealias Tasks = [String : Task]

struct Task: Codable {
    let createdOn: Int?
    let description: String?
    let sld: String?
    let progress: Int?
}
