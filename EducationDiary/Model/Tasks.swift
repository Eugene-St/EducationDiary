//
//  Task.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import UIKit

typealias Tasks = [String : Task]

struct Task: Codable {
    let createdOn: Int?
    let description: String?
    let sld: String?
    let progress: Int?
}

struct TaskAttributes {
    let attribute: String
    
    var strikeThrough: NSAttributedString {
            
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: attribute)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
            return attributeString
        }
    
    var regular: NSAttributedString {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: attribute)
        attributeString.addAttribute(.accessibilityTextCustom, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    let key: String?
    let value: Any?
}
