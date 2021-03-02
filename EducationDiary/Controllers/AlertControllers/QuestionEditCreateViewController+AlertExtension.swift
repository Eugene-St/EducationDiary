//
//  QuestionEditCreateViewController+AlertExtension.swift
//  EducationDiary
//
//  Created by Eugene St on 02.03.2021.
//

import UIKit

extension QuestionEditCreateViewController {
    
    func showCancelAlert() {
        
        let message: String = {
            let message: String
            if changesMade {
                message = "You have unsaved changes"
            } else {
                message = ""
            }
            return message
        }()
        
        let ac = UIAlertController(title: "Are you sure you want to cancel ?", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Yes", style: .default) { _ in
        self.navigationController?.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        ac.addAction(cancelAction)
        ac.addAction(okAction)
        present(ac, animated: true, completion: nil)
    }
}
