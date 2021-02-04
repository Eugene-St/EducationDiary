//
//  Mediator.swift
//  EducationDiary
//
//  Created by Eugene St on 01.02.2021.
//

import Foundation

class Mediator {
    
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
}




































