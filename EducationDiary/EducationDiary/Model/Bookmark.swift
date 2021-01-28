//
//  Bookmark.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import Foundation

struct Bookmark: Codable {
    
    let name: String?
    let text: String?
    
    typealias Bookmarks = [String: Bookmark]
}
