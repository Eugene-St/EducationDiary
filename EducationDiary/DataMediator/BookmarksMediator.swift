//
//  BookmarksMediator.swift
//  EducationDiary
//
//  Created by Eugene St on 01.02.2021.
//

import Foundation
import CoreData

class BookmarksMediator: Mediator<Bookmarks> {
    
    init() {
        super.init(.bookmarks, pathForUpdate: .bookmarksUpdate, object: BookmarkCoreData.self)
    }
    
    func saveToDB(_ bookmark: Bookmark) {
        let bookmarkCD = BookmarkCoreData(context: CoreDataManager.shared.context)
        bookmarkCD.name = bookmark.name
        bookmarkCD.text = bookmark.text
        bookmarkCD.sld = bookmark.sld
        CoreDataManager.shared.saveItems()
    }
}
