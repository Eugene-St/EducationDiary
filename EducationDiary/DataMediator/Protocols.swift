//
//  Protocols.swift
//  EducationDiary
//
//  Created by Eugene St on 03.02.2021.
//

import Foundation

// component of mediator
protocol Interactor {
    var viewController: DataUpdateableController { get set }
    var mediator: DataMediator { get set }
    func fetchData()
    func didUpdate(with data: Data)
    func didFail(with error: Error)
}

protocol DataUpdateableController {
    var interactor: Interactor? { get set }
    func updateUI(with data: Any)
}

extension Interactor {
    func parseJSON<T: Decodable>(data: Data, type: T.Type) -> T? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            return nil
        }
    }
}
