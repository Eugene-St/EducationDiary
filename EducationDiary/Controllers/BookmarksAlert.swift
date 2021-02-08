//
//  BookmarksAlert.swift
//  EducationDiary
//
//  Created by Eugene St on 05.02.2021.
//

import Foundation
import UIKit

extension BookmarksViewController {
    
    func showAlert(title: String, message: String, name: String? = nil, text: String? = nil, id: String?, httpMethod: HTTPMethods){
        
        var dataToPass: [String: String] = [:]
        
        var idForHttp: String
        
        if id == nil {
            let timeStamp = String(format: "%.0f", Date.timeIntervalSinceReferenceDate)
            idForHttp = "\(timeStamp)"
        } else {
            idForHttp = id!
        }
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            
            if let name = ac.textFields?.first?.text {
                dataToPass["name"] = name
            }
            
            if let text = ac.textFields?.last?.text {
                dataToPass["text"] = text
            }
            
            self?.mediator?.updateData(with: idForHttp, and: dataToPass, httpMethod: httpMethod) { [weak self] result in
                
                switch result {
                
                case .success(_):
                    self?.bookmarks[idForHttp] = Bookmark(name: dataToPass["name"], text: dataToPass["text"])
                    self?.tableView.reloadData()
                    
                    DispatchQueue.global(qos: .background).async {
                        // todo: save to core data here
                    }
                    
                case .failure(let error):
                    self?.noNetworkAlert(error: error)
                }
            }
        }
        
        ac.addTextField { nameTextfield in
            nameTextfield.placeholder = "name - optional"
            nameTextfield.autocapitalizationType = .sentences
            nameTextfield.text = name
            
            if id != nil {
                
                NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: nameTextfield, queue: OperationQueue.main) { _ in
                    
                    let textCount = nameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                    
                    let textIsNotEmpty = textCount > 0
                    
                    okAction.isEnabled = textIsNotEmpty
                }
            }
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
            self.present(ac, animated: true, completion: nil)
        }
    }
    
    func noNetworkAlert(error: Error) {
        let ac = UIAlertController(title: "No network connection", message: "We cannot delete the record, re-check internet, \(error)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        ac.addAction(okAction)
        DispatchQueue.main.async {
            self.present(ac, animated: true)
        }
    }
}

