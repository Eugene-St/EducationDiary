//
//  BookmarksInteractor.swift
//  EducationDiary
//
//  Created by Eugene St on 01.02.2021.
//

import Foundation

class BookmarksInteractor: Interactor {
    var mediator: DataMediator
    var viewController: DataUpdateableController
    
    init(controller: DataUpdateableController) {
        self.viewController = controller
        self.mediator = DataMediator.shared
    }
    
    func fetchData() {
        mediator.fetchData(with: "bookmarks.json", interactor: self)
    }
    
    func didUpdate(with data: Data) {
        if let decodedData = parseJSON(data: data, type: Bookmarks.self) {
            DispatchQueue.main.async {
                self.viewController.updateUI(with: decodedData)
            }
        }
    }
    
    func didFail(with error: Error) {
        print("BookmarksInteractor ERROR:\(error.localizedDescription)")
    }
    
}
