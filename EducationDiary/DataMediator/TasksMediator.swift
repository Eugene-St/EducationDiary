//
//  TasksMediator.swift
//  EducationDiary
//
//  Created by Eugene St on 01.02.2021.
//

import Foundation

class TasksMediator: Mediator<Tasks> {
    
    init() {
        super.init(.tasks, "", "")
    }
}
