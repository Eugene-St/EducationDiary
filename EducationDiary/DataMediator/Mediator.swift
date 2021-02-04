//
//  Mediator.swift
//  EducationDiary
//
//  Created by Eugene St on 01.02.2021.
//

import Foundation

protocol Mediator {}

extension Mediator {
    
    // todo: universal PUT, DELETE, PATCH methods
    
    var networkIsAvaible: Bool {
        return NetworkMonitor.shared.isReachable
    }
    
    func parseJSON<T: Decodable>(data: Data, type: T.Type) -> T? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            return nil
        }
    }
    
    func fetchDataFromNetwork<T: Codable>(of type: T.Type , path: EndType, _ completion: @escaping (result<T>)) {
        NetworkManager.shared.getRequest(path: path.rawValue) { result in
            
            switch result {
            
            case .failure(let error):
                completion(.failure(error))
                
            case .success(let data):
                if let decodedData = self.parseJSON(data: data, type: T.self) {
                    DispatchQueue.main.async {
                        completion(.success(decodedData))
                    }
                }
            }
        }
    }
}




































