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
    
    // save to DB
    override func saveToDB(_ object: Bookmarks) {
        object.forEach { (_, bookmark) in
            createInDB(bookmark: bookmark)
        }
    }
    
    // fetch from DB
    override func fetchFromDB(_ completion: @escaping ResultClosure<Bookmarks>) {
        CoreDataManager.shared.fetch(BookmarkCoreData.self) { result in
            switch result {
            
            case .success(let bookmarkObjects):
                var bookmarks: [String : Bookmark] = [:]
                
                bookmarkObjects.forEach { bookmarkObject in
                    bookmarks[bookmarkObject.sld ?? ""] = Bookmark(
                        name: bookmarkObject.name,
                        text: bookmarkObject.text,
                        sld: bookmarkObject.sld)
                }
                
                DispatchQueue.main.async {
                    completion(.success(bookmarks))
                }
                
            case .failure(let error):
            completion(.failure(error))
            }
        }
    }
    
    // delete single entity from db
    override func deleteFromDB(_ model: Model) {
        let request = CoreDataManager.shared.fetchRequest(BookmarkCoreData.self)
        
        do {
            let objects = try CoreDataManager.shared.context.fetch(request)
            
            objects.forEach { bookmarkCD in
                if model.modelId == bookmarkCD.sld {
                    CoreDataManager.shared.deleteItem(bookmarkCD)
                    CoreDataManager.shared.saveItems()
                }
            }
            
        } catch {
            print("Error deleting: \n \(error.localizedDescription)")
            Alert.errorAlert(error: error)
        }
    }
    
    override func updateInDB(_ model: Model) {
        let request = CoreDataManager.shared.fetchRequest(BookmarkCoreData.self)
        
        do {
            let objects = try CoreDataManager.shared.context.fetch(request)
            
            objects.forEach { bookmarkCD in
                let bookmark = model as! Bookmark
                if model.modelId == bookmarkCD.sld {
                    bookmarkCD.name = bookmark.name
                    bookmarkCD.text = bookmark.text
                    bookmarkCD.sld = bookmark.sld
                    CoreDataManager.shared.saveItems()
                }
            }
            
        } catch {
            print("Error updating: \n \(error.localizedDescription)")
            Alert.errorAlert(error: error)
        }
    }
    
    override func createInDB(_ model: Model) {
        let bookmark = model as! Bookmark
        createInDB(bookmark: bookmark)
    }
    
    // delete all entities from DB
    override func deleteEntitiesFromDB() {
        CoreDataManager.shared.resetAllRecords(in: "BookmarkCoreData")
    }
    
    private func createInDB(bookmark: Bookmark) {
        let bookmarkCD = BookmarkCoreData(context: CoreDataManager.shared.context)
        bookmarkCD.name = bookmark.name
        bookmarkCD.text = bookmark.text
        bookmarkCD.sld = bookmark.sld
        CoreDataManager.shared.saveItems()
    }
}
