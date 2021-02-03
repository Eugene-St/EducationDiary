//
//  NetworkManager.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    private let hostURL = URL(string:"https://testapp-3135f-default-rtdb.firebaseio.com/")
    typealias result<T> = (Result<T, Error>) -> Void
    private init() {}
    
    // MARK: - GET
    func getRequest<T: Codable>(of type: T.Type,
                                path: String,
                                _ completion: @escaping result<T>) {
        
        guard let hostURL = hostURL else { return }
        
        let url = hostURL.appendingPathComponent(path)
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print(error); completion(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(DataError.invalidResponse))
                return
            }
            
            if 200...299 ~= response.statusCode {
                if let data = data {
                    
                    do {
                        let decodeData:T = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodeData))
                    } catch {
                        completion(.failure(DataError.decodingError))
                    }
                } else {
                    completion(.failure(DataError.invalidData))
                }
            } else {
                completion(.failure(DataError.serverError))
            }
        }.resume()
    }
    
    // MARK: - DELETE
    func deleteRequest(path: String, id: String, _ completion: @escaping (Error?) -> Void) {
        
        guard let hostURL = hostURL else {
            print(DataError.invalidURL)
            return }
        
        let url = hostURL.appendingPathComponent(path + id)
        
        var request = URLRequest(url: url)
        
        request.httpMethod = HTTPMethods.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
                guard error == nil else {
                    print("Error: error calling DELETE")
                    completion(error)
                    return
                }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                let errorString = String(data: data ?? Data(), encoding: .utf8) ?? ""
                completion(NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: errorString]))
                return
            }
            
//                guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
//                    print("Error: HTTP request failed")
//                    completion(NSError(domain: "", code: , userInfo: [NSLocalizedDescriptionKey: ""]))
//                    return
//                }
            
            completion(nil)
            
        }.resume()
    }
    
    // MARK: - PUT
    func putRequest(path: String, id: String, body: [String: String], _ completion: @escaping (Error?) -> Void) {
        
        guard let hostURL = hostURL else { return }
        let url = hostURL.appendingPathComponent(path + id + ".json")
        
        let putData = body
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethods.put.rawValue
        
        do {
            let data = try JSONSerialization.data(withJSONObject: putData, options: [])
            
            urlRequest.httpBody = data
            urlRequest.setValue("application/json", forHTTPHeaderField: "content-type")
            
            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                
                if let error = error {
                    print(error); completion(error)
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completion(DataError.invalidResponse)
                    return
                }
                
                if 200...299 ~= response.statusCode {
                    if data != nil {
                        print("success put")
                    } else {
                        completion(DataError.invalidData)
//                guard let data = data else { return }
                    }
                } else {
                    completion(DataError.serverError)
                }
           
            
            }.resume()
        } catch {
            completion(error)
        }
    }
    
    // MARK: - PATCH
    func patchRequest(path: String) {
        
        guard let hostURL = hostURL else { return }
        
        let url = hostURL.appendingPathComponent(path)
    }
}




