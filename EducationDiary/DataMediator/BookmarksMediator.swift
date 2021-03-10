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
    
    override func fetchFromCoreData(_ completion: @escaping ResultClosure<Bookmarks>) {
        CoreDataManager.shared.fetch(BookmarkCoreData.self) { result in
            
            switch result {
            case .success(let objects):
                
                var bookmarks: [String : Bookmark] = [:]
                
                objects.forEach { object in
                    bookmarks[object.sld ?? ""] = Bookmark(
                        name: object.name,
                        text: object.text,
                        sld: object.sld)
                }
                
                DispatchQueue.main.async {
                    completion(.success(bookmarks))
                }
                
            case .failure(let error):
            completion(.failure(error))
            }
        }
    }
    
    func saveToDB(_ bookmark: Bookmark) {
        let bookmarkCD = BookmarkCoreData(context: CoreDataManager.shared.context)
        bookmarkCD.name = bookmark.name
        bookmarkCD.text = bookmark.text
        bookmarkCD.sld = bookmark.sld
        CoreDataManager.shared.saveItems()
    }
}
