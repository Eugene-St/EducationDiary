//
//  ErrorAlert.swift
//  EducationDiary
//
//  Created by Eugene St on 23.02.2021.
//

import UIKit

class Alert {
    
    static func errorAlert(error: Error) {
        
        let ac = UIAlertController(title: "Error", message: "We cannot proceed, \(error)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        ac.addAction(okAction)
        
        var rootViewController = UIApplication.shared.windows.first?.rootViewController
//        keyWindow?.rootViewController
        
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        
        DispatchQueue.main.async {
            rootViewController?.present(ac, animated: true)
        }
    }
}
