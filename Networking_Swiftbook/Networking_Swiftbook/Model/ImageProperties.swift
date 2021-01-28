//
//  ImageProperties.swift
//  Networking_Swiftbook
//
//  Created by Eugene St on 21.01.2021.
//

import UIKit

struct ImageProperties {
    let key: String
    let data: Data
    
    init?(image: UIImage, forKey key: String) {
        self.key = key
        guard let data = image.pngData() else { return nil }
        self.data = data
    }
}
