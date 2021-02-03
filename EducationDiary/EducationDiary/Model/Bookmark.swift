//
//  Bookmark.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import Foundation

typealias Bookmarks = [String: Bookmark]

struct Bookmark: Codable {
    let name: String?
    let text: String?
}
