//
//  Mediator.swift
//  EducationDiary
//
//  Created by Eugene St on 01.02.2021.
//

import Foundation

class Mediator<T: Decodable>{
    
    private let pathForFetch: EndType
    private let pathForDelete: String
    private let pathForPut: String
    
    init(_ pathForFetch: EndType, _ pathForString: String, _ pathForPut: String) {
        self.pathForFetch = pathForFetch
        self.pathForDelete = pathForString
        self.pathForPut = pathForPut
    }
    
    //MARK: networkIsAvaible
    private var networkIsAvaible: Bool {
        return NetworkMonitor.shared.isReachable
    }
    
    //MARK: parseJSON
    private func parseJSON(data: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            return nil
        }
    }
    
    //MARK: Recognise result
    private func recogniseResult(_ result: Result<Data, Error>, _ completion: @escaping (result<T>)) {
        switch result {
        case .failure(let error):
            completion(.failure(error))
        case .success(let data):
            if let decodedData = self.parseJSON(data: data) {
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            }
        }
    }
    
    private func recogniseResult<T>(_ result: Result<T, Error>, _ completion: @escaping (result<T>)) {
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
    
    //MARK: Fetch data
    func fetchData(_ completion: @escaping result<T>) {
        if networkIsAvaible {
            NetworkManager.shared.getRequest(path: pathForFetch.rawValue) { result in
                self.recogniseResult(result, completion)
            }
        } else {
//            print("fetch data from DB")
            completion(.failure(DataError.noNetwork))
        }
    }
    
    //MARK: Delete data
    func deleteData(with id: String, _ completion: @escaping result<URLResponse>) {
        if networkIsAvaible {
            NetworkManager.shared.deleteRequest(path: pathForDelete, id: id) { result in
                self.recogniseResult(result, completion)
            }
        } else {
            print("Remove from DB")
        }
    }
    
    //MARK: Put data
    func updateData(with id: String, and body: [String: String], httpMethod: HTTPMethods, _ completion: @escaping result<URLResponse>){
        if networkIsAvaible {
            NetworkManager.shared.updateRequest(path: pathForPut, id: id, body: body, httpMethod: httpMethod) { result in
                self.recogniseResult(result, completion)
            }
        } else {
            print("Put to DB")
        }
    }
    
}




































