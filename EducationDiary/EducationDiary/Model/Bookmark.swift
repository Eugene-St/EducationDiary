//
//  Bookmark.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import Foundation

let host = "https://testapp-3135f-default-rtdb.firebaseio.com//bookmarks.json"

struct BookmarkValue: Codable {
    
    let name: String?
    let text: String?
}

typealias Bookmark = [String: BookmarkValue]
