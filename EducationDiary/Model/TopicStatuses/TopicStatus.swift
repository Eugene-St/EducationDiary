//
//  TopicStatus.swift
//  EducationDiary
//
//  Created by Eugene St on 24.02.2021.
//

import UIKit

enum TopicStatus: String {
    case unstarted = "Unstarted"
    case inProgress = "In progress"
    case onHold = "On Hold"
    case done = "Done"
    
    var associatedColor: UIColor {
        switch self {
        case .unstarted: return .black
        case .inProgress: return .systemBlue
        case .onHold: return .systemGray
        case .done: return .systemGreen
        }
    }
}
