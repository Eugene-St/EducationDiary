//
//  FreezeUIController.swift
//  EducationDiary
//
//  Created by Eugene St on 23.02.2021.
//

import UIKit

class FreezeUIController {
    
    static let sharedInstance = FreezeUIController()
    
    private var freezeView: UIView = {
        let freezeView = UIView()
        freezeView.backgroundColor = .white
        return freezeView
    }()
    
    private let loginSpinner: UIActivityIndicatorView = {
        let loginSpinner = UIActivityIndicatorView(style: .large)
        loginSpinner.translatesAutoresizingMaskIntoConstraints = false
        loginSpinner.tintColor = .green
        loginSpinner.hidesWhenStopped = true
        return loginSpinner
    }()
    
    private init() {}
    
    func freezeUI(for controller: UITableViewController) {
        freezeView.frame = controller.view.frame
        controller.view.addSubview(freezeView)
        freezeView.alpha = 0.1
        controller.view.addSubview(loginSpinner)
        loginSpinner.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor).isActive = true
        loginSpinner.centerYAnchor.constraint(equalTo: controller.view.centerYAnchor).isActive = true
        controller.tableView.alwaysBounceVertical = false
        loginSpinner.startAnimating()
    }
    
    func disableUIFreeze(for controller: UITableViewController) {
        freezeView.frame = controller.view.frame
        freezeView.alpha = 0
        loginSpinner.stopAnimating()
        controller.tableView.alwaysBounceVertical = true
    }
}