//
//  WebsiteDescription.swift
//  Networking_Swiftbook
//
//  Created by Eugene St on 20.01.2021.
//

import Foundation

struct WebsiteDescription: Codable {
    
    let websiteDescription: String?
    let websiteName: String?
    let courses: [Course]
}
