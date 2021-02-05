//
//  BookmarksMediator.swift
//  EducationDiary
//
//  Created by Eugene St on 01.02.2021.
//

import Foundation

class BookmarksMediator: Mediator {
    
    func fetchData(_ completion: @escaping result<Bookmarks>) {
        
        if networkIsAvaible {
            
            fetchDataFromNetwork(of: Bookmarks.self, path: .bookmarks) { result in
                switch result {
                
                case .success(let bookmarks):
                    completion(.success(bookmarks))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            print("fetch data from DB")
        }
    }
    
    func putData(with id: String, and body: [String: String], _ completion: @escaping result<URLResponse>) {
        
        if networkIsAvaible {
            
            NetworkManager.shared.putRequest(path: "/bookmarks/", id: id, body: body) { result in
                
                switch result {
                
                case .success(let response):
                    DispatchQueue.main.async {
                        completion(.success(response))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        } else {
            print("Alert that does not allow to delete")
        }
    }
    
    func deleteData(with id: String, _ completion: @escaping result<URLResponse>) {
        
        if networkIsAvaible {
            
            NetworkManager.shared.deleteRequest(path: "bookmarks/", id: id) { result in
                switch result {
                
                case .success(let response):
                    DispatchQueue.main.async {
                        completion(.success(response))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        } else {
            print("Alert that does not allow to delete")
        }
    }
}
