//
//  NetworkAvailability.swift
//  EducationDiary
//
//  Created by Eugene St on 01.02.2021.
//

import Foundation
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            
            if path.status == .satisfied {
                print("We're connected!")
            } else {
                print("No connection.")
            }
        }
        
        let queue = DispatchQueue(label: "Network Monitor")
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
// Класс Singleton Network Availability - на протяжении жизни приложения живет (может быть как отдельная сущность или составляющая Network Manager)



