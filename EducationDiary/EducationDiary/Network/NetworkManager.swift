//
//  NetworkManager.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func fetchData(_ completion: @escaping ([String: Bookmark]) -> Void) {
        guard let url = URL(string: "https://testapp-3135f-default-rtdb.firebaseio.com//bookmarks.json") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error { print(error); return }
            guard let data = data else { return }
            
            do {
                let bookmarks = try JSONDecoder().decode([String: Bookmark].self, from: data)
                completion(bookmarks)
            } catch let jsonError {
                print("Error while parsing the data", jsonError)
            }
        }.resume()
    }
}

//JSONDecoder().decode(model.self, from: data)




