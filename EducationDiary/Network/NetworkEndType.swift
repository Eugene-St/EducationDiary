//
//  NetworkEndType.swift
//  EducationDiary
//
//  Created by Eugene St on 04.02.2021.
//

import Foundation

enum EndType: String {
    case bookmarks = "bookmarks.json"
    case topics = "topics.json"
    case questions = "questions.json"
    case tasks = "tasks.json"
    
    case bookmarksUpdate = "bookmarks/"
    case topicsUpdate = "topics/"
    case questionsUpdate = "questions/"
    case tasksUpdate = "tasks/"
}
