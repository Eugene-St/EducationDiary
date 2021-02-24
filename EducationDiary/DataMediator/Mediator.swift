//
//  Mediator.swift
//  EducationDiary
//
//  Created by Eugene St on 01.02.2021.
//

import Foundation

class Mediator<T: Decodable>{
    
    private let pathForFetch: EndType
    private let pathForUpdate: EndType
    
    init(_ pathForFetch: EndType, pathForUpdate: EndType) {
        self.pathForFetch = pathForFetch
        self.pathForUpdate = pathForUpdate
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
            // todo
            return nil
        }
    }
    
    //MARK: Recognise result
    private func recogniseResult(_ result: Result<Data, Error>, _ completion: @escaping (ResultClosure<T>)) {
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
    
    private func recogniseResult<T>(_ result: Result<T, Error>, _ completion: @escaping (ResultClosure<T>)) {
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
    
    //MARK: FETCH data
    func fetchData(_ completion: @escaping ResultClosure<T>) {
        if networkIsAvaible {
            NetworkManager.shared.getRequest(path: pathForFetch.rawValue) { result in
                self.recogniseResult(result, completion)
            }
        } else {
            //            print("fetch data from DB")
            completion(.failure(DataError.noNetwork))
        }
    }
    
    //MARK: DELETE data
    func deleteData(for model: Model, _ completion: @escaping ResultClosure<URLResponse>) {
        if networkIsAvaible {
            NetworkManager.shared.deleteRequest(path: pathForUpdate.rawValue, id: model.modelId) { result in
                self.recogniseResult(result, completion)
            }
        } else {
            completion(.failure(DataError.noNetwork))
            print("Remove from DB")
        }
    }
    
    // MARK: - PATCH Data
    func updateData<T: Codable>(for model: T, _ completion: @escaping ResultClosure<URLResponse>) {
        
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(model) else {
            completion(.failure(DataError.invalidData))
            return
        }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
            completion(.failure(DataError.decodingError))
            return
        }
        
        let model = model as! Model
        
        if networkIsAvaible {
            NetworkManager.shared.patchRequest(path: pathForUpdate.rawValue, id: model.modelId, body: json) { result in
                self.recogniseResult(result, completion)
            }
        } else {
            completion(.failure(DataError.noNetwork))
            print("Put to DB")
        }
    }
    
    
    // MARK: - PUT data
    func createNewData<T: Codable>(for model: T, _ completion: @escaping ResultClosure<URLResponse>) {
        
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(model) else {
            completion(.failure(DataError.invalidData))
            return
        }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
            completion(.failure(DataError.decodingError))
            return
        }
        
        let model = model as! Model
        
        if networkIsAvaible {
            NetworkManager.shared.putRequest(path: pathForUpdate.rawValue, id: model.modelId, body: json) { result in
                self.recogniseResult(result, completion)
            }
        } else {
            completion(.failure(DataError.noNetwork))
            print("Put to DB")
        }
    }
}




































