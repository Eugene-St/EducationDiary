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
    case noStatus = "Oops, no status"
    
    var associatedColor: UIColor {
        switch self {
        case .unstarted: return .systemGray
        case .inProgress: return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        case .onHold: return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        case .done: return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        case .noStatus: return .systemRed
        }
    }
}
