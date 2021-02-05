//
//  NetworkManager.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import Foundation

typealias result<T> = (Result<T, Error>) -> Void

class NetworkManager {
    
    // todo: realize PATCH method
    
    static let shared = NetworkManager()
    private let hostURL = URL(string:"https://testapp-3135f-default-rtdb.firebaseio.com/")
    private init() {}
    
    // MARK: - GET
    func getRequest(path: String,
                    _ completion: @escaping result<Data>) {
        
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
                    
                    completion(.success(data))
                    
                } else {
                    completion(.failure(DataError.invalidData))
                }
            } else {
                completion(.failure(DataError.serverError))
            }
        }.resume()
    }
    
    // MARK: - DELETE
    func deleteRequest(path: String, id: String, _ completion: @escaping result<URLResponse>) {
        
        guard let hostURL = hostURL else {
            print(DataError.invalidURL)
            return }
        
        let url = hostURL.appendingPathComponent(path + id)
        
        var request = URLRequest(url: url)
        
        request.httpMethod = HTTPMethods.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Error: error calling DELETE")
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                completion(.failure(DataError.serverError))
                return
            }
                completion(.success(response))
        }.resume()
    }
    
    // MARK: - PUT
    func putRequest(path: String, id: String, body: [String: String], _ completion: @escaping result<URLResponse>) {
        
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
                    print(error); completion(.failure(error))
                }
                
                if let response = response as? HTTPURLResponse {
                    
                    if 200...299 ~= response.statusCode {
                        if data != nil {
                            completion(.success(response))
                        } else {
                            completion(.failure(DataError.invalidData))
                            //                guard let data = data else { return }
                        }
                    } else {
                        completion(.failure(DataError.serverError))
                    }
                } else {
                    completion(.failure(DataError.invalidResponse))
                }
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
    
    // MARK: - PATCH
    func patchRequest(path: String) {
        
        guard let hostURL = hostURL else { return }
        
        let url = hostURL.appendingPathComponent(path)
    }
}




