//
//  DataMediator.swift
//  EducationDiary
//
//  Created by Eugene St on 01.02.2021.
//

import Foundation

class DataMediator {
    
    static let shared = DataMediator()
    private init(){}
    
//    var bookmarksInteractor: Interactor?
//    var questionsInteractor: Interactor?
//    var topicsInteractor: Interactor?
//    var tasksInteractor: Interactor?
    
    var networkAvaible: Bool {
        return NetworkMonitor.shared.isReachable
    }
    
    //todo: create method to define data source
    func fetchData(with path: String, interactor: Interactor) {
        if networkAvaible {
            print("Network available, fetch data from BE")
            
            NetworkManager.shared.getRequest(path: path) { result in
                switch result {
                case .failure(let error):
                    interactor.didFail(with: error)
                
                case .success(let data):
                    interactor.didUpdate(with: data)
                }
            }
            
        } else {
            print("No network, fetch data from Core Data")
        }
    }
    // todo: fetch data from defined data source (remote or local DB)
}




































