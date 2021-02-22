//
//  Bookmark.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import Foundation

typealias Bookmarks = [String: Bookmark]

struct Bookmark: Model {
    
    var name: String?
    var text: String?
    let sld: String?
    
    var modelId: String {
        return sld ?? ""
    }
}

class BookmarkViewModel {
    var bookmark: Bookmark
    let key: String
    
    init(bookmark: Bookmark, key: String) {
        self.bookmark = bookmark
        self.key = key
    }
}
