//
//  BookmarksMediator.swift
//  EducationDiary
//
//  Created by Eugene St on 01.02.2021.
//

import Foundation

class BookmarksMediator: Mediator {

    func fetchData( _ completionError: @escaping (Error) -> Void, _ completionSuccess: @escaping (Bookmarks) -> Void) {
        
        if networkAvaible {
            NetworkManager.shared.getRequest(path: "bookmarks.json") { result in
                
                switch result {
                
                case .failure(let error):
                    completionError(error)
                
                case .success(let data):
                    if let decodedData = self.parseJSON(data: data, type: Bookmarks.self) {
                        DispatchQueue.main.async {
                            completionSuccess(decodedData)
                        }
                    }
                }
            }
        }
    }
    
    func putData(with id: String, and body: [String: String], _ completion: @escaping (Bool) -> ()) {
        NetworkManager.shared.putRequest(path: "/bookmarks/", id: id, body: body) { error in
            if let err = error {
                print("Failed to put", err)
                return
            }
            
            DispatchQueue.main.async {
                completion(true)
            }
        }
    }
    
}