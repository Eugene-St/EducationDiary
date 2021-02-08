//
//  BookmarksMediator.swift
//  EducationDiary
//
//  Created by Eugene St on 01.02.2021.
//

import Foundation

class BookmarksMediator: Mediator<Bookmarks> {
    
    init() {
        super.init(.bookmarks, pathForUpdate: .bookmarksUpdate)
    }
}
