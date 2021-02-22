//
//  BookmarksAlert.swift
//  EducationDiary
//
//  Created by Eugene St on 05.02.2021.
//

import Foundation
import UIKit

extension BookmarksViewController {
    
    //todo: refactor (swiftlint)
    func showAlert(title: String, message: String, bookmark: Bookmark? = nil) {
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            
            if bookmark == nil {
                self?.createNewBookmarkFor(alertController: ac)
            } else {
                self?.updateBookmarkFor(bookmark, and: ac)
            }
        }
        
        ac.addTextField { nameTextfield in
            nameTextfield.placeholder = "name - optional"
            nameTextfield.autocapitalizationType = .sentences
            nameTextfield.text = bookmark?.name
            
            if bookmark != nil {
                
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
            textField.text = bookmark?.text
            
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
    
    private func createNewBookmarkFor(alertController: UIAlertController) {
        
        let timeStamp = Int(Date.timeIntervalSinceReferenceDate)
        let bookmark = Bookmark(name: alertController.textFields?.first?.text, text: alertController.textFields?.last?.text, sld: String(timeStamp))
        let newBookmarkModel = BookmarkViewModel(bookmark: bookmark, key: String(timeStamp))
        
        mediator.createNewData(for: bookmark) { [weak self] result in
            switch result {
            
            case .success(_):
                self?.bookmarkViewModels.insert(newBookmarkModel, at: 0)
                self?.tableView.reloadData()
                
                DispatchQueue.global(qos: .background).async {
                    // todo: save to core data here
                }
                
            case .failure(let error):
                Alert.errorAlert(error: error)
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateBookmarkFor(_ bookmark: Bookmark?, and alertController: UIAlertController) {
        
        let bookmark = Bookmark(name: alertController.textFields?.first?.text, text: alertController.textFields?.last?.text, sld: bookmark?.sld)
        let bookmarkModel = BookmarkViewModel(bookmark: bookmark, key: bookmark.sld ?? "")
        
        mediator.updateData(for: bookmark) { [weak self] result in
            switch result {
            
            case .success(_):
                if let index = self?.bookmarkViewModels.firstIndex(where: { $0.key == bookmarkModel.key }) {
                    self?.bookmarkViewModels[index] = bookmarkModel
                }
                self?.tableView.reloadData()
                
                DispatchQueue.global(qos: .background).async {
                    // todo: save to core data here
                }
                
            case .failure(let error):
                Alert.errorAlert(error: error)
                print(error.localizedDescription)
            }
        }
    }
}

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

