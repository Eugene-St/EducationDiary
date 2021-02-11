//
//  Extensions.swift
//  EducationDiary
//
//  Created by Eugene St on 11.02.2021.
//

import UIKit

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
