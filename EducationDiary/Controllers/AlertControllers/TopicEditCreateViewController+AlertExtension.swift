//
//  TopicsAlertController.swift
//  EducationDiary
//
//  Created by Eugene St on 23.02.2021.
//

import UIKit

extension TopicEditCreateViewController {
    func showStatusAlertController() {
        let ac = UIAlertController(title: "Please choose status",
                                   message: nil,
                                   preferredStyle: .actionSheet)
        
        let unstartedButton = UIAlertAction(title: TopicStatus.unstarted.rawValue,
                                            style: .default) { [weak self] _ in
            self?.configureStatusandStatusButton(with: .unstarted)
        }
        
        let onHoldButton = UIAlertAction(title: TopicStatus.onHold.rawValue,
                                         style: .default) { [weak self] _ in
            self?.configureStatusandStatusButton(with: .onHold)
        }
        
        let inProgressButton = UIAlertAction(title: TopicStatus.inProgress.rawValue,
                                             style: .default) { [weak self] _ in
            self?.configureStatusandStatusButton(with: .inProgress)
        }
        
        let doneButton = UIAlertAction(title: TopicStatus.done.rawValue,
                                       style: .default) { [weak self] _ in
            self?.configureStatusandStatusButton(with: .done)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            print("Cancel pressed")
        }
        
        ac.addAction(unstartedButton)
        ac.addAction(onHoldButton)
        ac.addAction(inProgressButton)
        ac.addAction(doneButton)
        ac.addAction(cancelButton)
        present(ac, animated: true, completion: nil)
    }
    
    private func configureStatusandStatusButton(with status: TopicStatus) {
        topicStatusButton.setTitle(status.rawValue, for: .normal)
        topicStatusButton.backgroundColor = status.associatedColor
    }
    
    func showInfoAlert() {
        let ac = UIAlertController(title: "Please fill in the necessary info",
                                   message: "Title, Topic and Due Date are required fields",
                                   preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default)
        
        ac.addAction(okAction)
        present(ac, animated: true)
    }
    
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
        
        let ac = UIAlertController(title: "Are you sure you want to cancel ?",
                                   message: message,
                                   preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        ac.addAction(cancelAction)
        ac.addAction(okAction)
        present(ac, animated: true, completion: nil)
    }
}
