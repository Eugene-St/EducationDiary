//
//  TasksMediator.swift
//  EducationDiary
//
//  Created by Eugene St on 01.02.2021.
//

import Foundation

class TasksMediator: Mediator {
    
    func fetchData(_ completion: @escaping result<Tasks>) {
        
        if networkIsAvaible {
            fetchDataFromNetwork(of: Tasks.self, path: .tasks) { result in
                switch result {
                
                case .success(let tasks):
                    
                    completion(.success(tasks))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            print("fetch data from DB")
        }
    }
}
