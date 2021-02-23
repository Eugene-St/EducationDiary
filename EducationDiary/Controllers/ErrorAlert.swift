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
        DispatchQueue.main.async {
            ac.present(ac, animated: true)
        }
    }
}
