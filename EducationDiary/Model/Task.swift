//
//  Task.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import UIKit

typealias Tasks = [String : Task]

struct Task: Model {

    let createdOn: Int32?
    let description: String?
    let sld: String?
    var progress: Int32?
    
    var modelId: String {
        return sld ?? ""
    }
}

class TaskViewModel {
    var task: Task
    let key: String
    var accessoryType: UITableViewCell.AccessoryType = .none
    var tintColor: UIColor? = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    
    init(task: Task, key: String) {
        self.task = task
        self.key = key
    }
}





