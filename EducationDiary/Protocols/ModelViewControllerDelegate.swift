//
//  ModelViewControllerDelegate.swift
//  EducationDiary
//
//  Created by Eugene St on 10.02.2021.
//

import Foundation

protocol ModelViewControllerDelegate {
    func saveData(for object: Model, with id: String)
}
