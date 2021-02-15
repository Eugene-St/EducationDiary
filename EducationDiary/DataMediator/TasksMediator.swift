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

}
