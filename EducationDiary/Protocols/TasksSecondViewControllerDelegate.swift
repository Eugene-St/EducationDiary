//
//  TasksSecondViewControllerDelegate.swift
//  EducationDiary
//
//  Created by Eugene St on 10.02.2021.
//

import Foundation

protocol TasksSecondViewControllerDelegate {
    func saveData(for task: Task, with id: String)
}
