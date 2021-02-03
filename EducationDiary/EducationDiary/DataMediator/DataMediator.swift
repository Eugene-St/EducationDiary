//
//  DataMediator.swift
//  EducationDiary
//
//  Created by Eugene St on 01.02.2021.
//

import Foundation

class DataMediator {
    
    //todo: create method to define data source
    func fetchData() {
        if NetworkMonitor.shared.isReachable {
            print("Network available, fetch data from BE")
        } else {
            print("No network, fetch data from Core Data")
        }
    }
    
    
    // todo: fetch data from defined data source (remote or local DB)
}




































