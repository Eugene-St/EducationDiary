//
//  Mediator.swift
//  EducationDiary
//
//  Created by Eugene St on 01.02.2021.
//

import Foundation
import CoreData

class Mediator<T: Decodable> {
    
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
            return nil
        }
    }
    
    //MARK: Recognise result
    private func recogniseResult(_ result: Result<Data, Error>, _ completion: @escaping (ResultClosure<T>)) {
        
        switch result {
        
        case .failure(let error):
            completion(.failure(error))
            
        case .success(let data):
            
            guard let decodedData = self.parseJSON(data: data) else {
                completion(.failure(DataError.decodingError))
                return
            }
            DispatchQueue.main.async {
                completion(.success(decodedData))
            }
            
//            DispatchQueue.global(qos: .background).async {
                self.deleteEntitiesFromDB()
            self.saveToDB(decodedData)
//            }
        }
    }
    
    private func recogniseResult<T>(_ result: Result<T, Error>, requestType: RequestTypes, _ model: Model, _ completion: @escaping (ResultClosure<T>)) {
        
        switch result {
        case .success(let response):
            
            DispatchQueue.main.async {
                completion(.success(response))
            }
            
            switch requestType {
            case .delete:
                deleteFromDB(model)
            case .update:
                updateInDB(model)
            case .create:
                createInDB(model)
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
            fetchDataFromNetwork(completion)
        } else {
            fetchFromDB(completion)
        }
    }
    
    private func fetchDataFromNetwork(_ completion: @escaping ResultClosure<T>) {
        NetworkManager.shared.getRequest(path: pathForFetch.rawValue) { result in
            self.recogniseResult(result, completion)
        }
    }
    
    //MARK: DELETE data
    func deleteData(for model: Model, _ completion: @escaping ResultClosure<URLResponse>) {
        if networkIsAvaible {
            NetworkManager.shared.deleteRequest(path: pathForUpdate.rawValue, id: model.modelId) { result in
                self.recogniseResult(result, requestType: .delete, model, completion)
            }
        } else {
            completion(.failure(DataError.noNetwork))
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
                self.recogniseResult(result, requestType: .update, model, completion)
            }
        } else {
            completion(.failure(DataError.noNetwork))
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
                self.recogniseResult(result, requestType: .create, model, completion)
            }
        } else {
            completion(.failure(DataError.noNetwork))
        }
    }
    
    func saveToDB(_ object: T) {}
    func updateInDB(_ model: Model) {}
    func createInDB(_ model: Model) {}
    func fetchFromDB(_ completion: @escaping ResultClosure<T>) {}
    func deleteFromDB(_ model: Model) {}
    func deleteEntitiesFromDB() {}
}




































