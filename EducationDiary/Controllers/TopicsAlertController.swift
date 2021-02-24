//
//  TopicsAlertController.swift
//  EducationDiary
//
//  Created by Eugene St on 23.02.2021.
//

import UIKit

extension TopicEditCreateViewController {
    
    func alertController() {
        let ac = UIAlertController(title: "Please choose status", message: "It is a required option", preferredStyle: .actionSheet)
        
        let unstartedButton = UIAlertAction(title: "Unstarted", style: .default) { [weak self] _ in
            self?.status = "Unstarted"
            print("Unstarted button pressed")
        }
        
        let onHoldButton = UIAlertAction(title: "On Hold", style: .default) { [weak self] _ in
            self?.status = "On Hold"
            print("onHold button pressed")
        }
        
        let inProgressButton = UIAlertAction(title: "In progress", style: .default) { [weak self] _ in
            self?.status = "In progress"
            print("inProgress Button pressed")
        }
        
        let doneButton = UIAlertAction(title: "Done", style: .default) { [weak self] _ in
            self?.status = "Done"
            print("Done button pressed")
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive) { [weak self] _ in
            print("Cancel pressed")
        }
        
        ac.addAction(unstartedButton)
        ac.addAction(onHoldButton)
        ac.addAction(inProgressButton)
        ac.addAction(doneButton)
        ac.addAction(cancelButton)
        present(ac, animated: true, completion: nil)
    }
}
