//
//  AlertController.swift
//  EducationDiary
//
//  Created by Eugene St on 05.02.2021.
//

import Foundation
import UIKit

class Alert {
    
    static func showAlert(title: String ,message: String, on vc: UITableViewController, mediator: BookmarksMediator?, name: String? = nil, text: String? = nil){
        
        var dataToPass: [String: String] = [:]
        let bookmarksVC = vc as! BookmarksViewController
        
        let timeStamp = String(format: "%.0f", Date.timeIntervalSinceReferenceDate)
        let id = "\(timeStamp)"
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            
            if let name = ac.textFields?.first?.text {
                dataToPass["name"] = name
            }
            
            if let text = ac.textFields?.last?.text {
                dataToPass["text"] = text
            }
            
            mediator?.putData(with: id, and: dataToPass) { result in
                
                switch result {
                
                case .success(_):
                    bookmarksVC.bookmarks[id] = Bookmark(name: dataToPass["name"], text: dataToPass["text"])
                    bookmarksVC.tableView.reloadData()
                    
                case .failure(let error):
                        let ac = UIAlertController(title: "No network connection", message: "We cannot add the record, re-check internet, \(error)", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default)
                        ac.addAction(okAction)
                        bookmarksVC.present(ac, animated: true)
                }
            }
            
            //            let insertionIndexPath = IndexPath(row: self.bookmarks.count - 1, section: 0)
            //            self.tableView.insertRows(at: [insertionIndexPath], with: .automatic)
        }
        
        ac.addTextField { nameTextfield in
                nameTextfield.placeholder = "name - optional"
                nameTextfield.autocapitalizationType = .sentences
                nameTextfield.text = name
        }
        
        ac.addTextField { textField in
            textField.placeholder = "text - required"
            textField.autocapitalizationType = .sentences
            textField.text = text
            
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main) { _ in
                
                let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                
                let textIsNotEmpty = textCount > 0
                
                okAction.isEnabled = textIsNotEmpty
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        ac.addAction(cancelAction)
        okAction.isEnabled = false
        ac.addAction(okAction)
        
        DispatchQueue.main.async {
            bookmarksVC.present(ac, animated: true, completion: nil)
        }
        
    }
}

