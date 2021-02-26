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
    
    func regular() -> NSAttributedString {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(.accessibilityTextCustom, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}

extension Calendar {
    
    // Number of days pass midnight, including a start date
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
            let fromDate = startOfDay(for: from)
            let toDate = startOfDay(for: to)
            let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)

            return numberOfDays.day!
        }
}
