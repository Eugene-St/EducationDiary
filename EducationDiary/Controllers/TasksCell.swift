//
//  TasksCell.swift
//  EducationDiary
//
//  Created by Eugene St on 11.02.2021.
//

import UIKit

class TasksCell: UITableViewCell {
    
    func configure(with taskViewModel: TaskViewModel) {

        if taskViewModel.task.progress == 100 {
            textLabel?.attributedText = taskViewModel.task.description?.strikeThrough()
            taskViewModel.accessoryType = .checkmark
            taskViewModel.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            accessoryType = taskViewModel.accessoryType
            tintColor = taskViewModel.tintColor
        } else {
            textLabel?.attributedText = taskViewModel.task.description?.regular()
            accessoryType = .none
        }
    }
}
