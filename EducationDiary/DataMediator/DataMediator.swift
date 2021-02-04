//
//  DataMediator.swift
//  EducationDiary
//
//  Created by Eugene St on 01.02.2021.
//

import Foundation

class DataMediator {
    
    static let shared = DataMediator()
    private init(){}

    var networkAvaible: Bool {
        return NetworkMonitor.shared.isReachable
    }
}




































