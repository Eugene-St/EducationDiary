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
    
    private var window: UIWindow? = {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        return window
    }()
    
    private init() {}
    
    func freezeUI() {
        window = UIApplication.shared.windows.first { $0.isKeyWindow }
        freezeView.frame = window?.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        window?.addSubview(freezeView)
        freezeView.backgroundColor = .black
        freezeView.alpha = 0.1
        window?.addSubview(loginSpinner)
        loginSpinner.centerXAnchor.constraint(equalTo: window?.centerXAnchor ?? NSLayoutXAxisAnchor()).isActive = true
        loginSpinner.centerYAnchor.constraint(equalTo: window?.centerYAnchor ?? NSLayoutYAxisAnchor()).isActive = true
        loginSpinner.startAnimating()
    }
    
    func disableUIFreeze() {
        freezeView.frame = window?.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        freezeView.backgroundColor = .clear
        freezeView.alpha = 0
        loginSpinner.stopAnimating()
    }
}
