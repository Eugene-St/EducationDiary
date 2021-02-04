//
//  BookmarksInteractor.swift
//  EducationDiary
//
//  Created by Eugene St on 01.02.2021.
//

import Foundation

class BookmarksInteractor: Interactor {

    var mediator: DataMediator
    var updateUICompletion: ((Bookmarks) -> Void)
    
    init(updatedDataUI: @escaping ((Bookmarks) -> Void)) {
        self.mediator = DataMediator.shared
        self.updateUICompletion = updatedDataUI
    }
    
    
    func fetchData() {
        mediator.fetchData(with: "bookmarks.json", interactor: self)
    }
    
    func didUpdate(with data: Data) {
        if let decodedData = parseJSON(data: data, type: Bookmarks.self) {
            DispatchQueue.main.async {
                self.updateUICompletion(decodedData)
            }
        }
    }
    
    func didFail(with error: Error) {
        print("BookmarksInteractor ERROR:\(error.localizedDescription)")
    }
    
    func putData(with id: String, and body: [String: String]) {
        NetworkManager.shared.putRequest(path: "/bookmarks/", id: id, body: body) { error in
            if let err = error {
                print("Failed to put", err)
                return
            }
        }
    }
    
}
