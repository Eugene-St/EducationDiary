//
//  TasksMediator.swift
//  EducationDiary
//
//  Created by Eugene St on 01.02.2021.
//

import UIKit

class TasksMediator: Mediator<Tasks> {
    init() {
        super.init(.tasks, pathForUpdate: .tasksUpdate)
    }
    
    // MARK: - Methods
//    func description(for task: Task, with text: String) -> String {
//        if task.progress == 100 {
//            return text.strikeThrough()
//        }
//    }
}
