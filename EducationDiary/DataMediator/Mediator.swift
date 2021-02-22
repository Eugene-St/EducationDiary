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
    
    //MARK: Fetch data
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
    
    //MARK: Delete data
    
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
    
    
    //MARK: Put data
    /*
    func updateData(with id: String?, body: [String: Any], httpMethod: HTTPMethods, _ completion: @escaping
                       // todo: updateData for Task и медиатор будет брать айдишник или генерить новый
                        // todo: генерация свойств перенести в модель
                        
                        ResultClosure<URLResponse>){
        if networkIsAvaible {
            NetworkManager.shared.putRequest(path: pathForUpdate.rawValue, id: id, body: body, httpMethod: httpMethod) { result in
                self.recogniseResult(result, completion)
            }
        } else {
            completion(.failure(DataError.noNetwork))
            print("Put to DB")
        }
    }
 */
    
    
    // MARK: - Save Data
    func updateData<T: Codable>(for model: T, _ completion: @escaping ResultClosure<URLResponse>) {
        
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(model) else { return }

        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else { return }
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
    
    
    // MARK: - Create New Data
    func createNewData<T: Codable>(for model: T, _ completion: @escaping ResultClosure<URLResponse>) {
        
        let encoder = JSONEncoder()
        let data = try? encoder.encode(model)

        guard let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any] else { return }
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




































