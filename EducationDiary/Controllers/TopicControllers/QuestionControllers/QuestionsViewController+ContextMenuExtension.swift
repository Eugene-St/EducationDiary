//
//  QuestionsViewController+ContextMenuExtension.swift
//  EducationDiary
//
//  Created by Eugene St on 02.03.2021.
//

import UIKit

extension QuestionsViewController {
    
    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil,
            actionProvider: { _ in
                let removeQuestion = self.removeQuestionAction(at: indexPath)
                let editQuestion = self.editQuestionAction(at: indexPath)
                let children = [removeQuestion, editQuestion]
                return UIMenu(title: "", children: children)
            })
    }
    
    private func removeQuestionAction(at index: IndexPath) -> UIAction {
        
        let removeAttribute = UIMenuElement.Attributes.destructive
        
        let deleteImage = UIImage(systemName: "trash.slash")
        
        return UIAction(
            title: "Remove question",
            image: deleteImage,
            identifier: nil,
            attributes: removeAttribute) { [weak self] _ in
            
            var questions = self?.topic?.questions
            
            questions?.remove(at: index.item)
            
            let topic = Topic(id: self?.topic?.id,
                              title: self?.topic?.title,
                              links: self?.topic?.links,
                              notes: self?.topic?.notes,
                              status: self?.topic?.status,
                              due_date: self?.topic?.due_date,
                              created_on: self?.topic?.created_on,
                              questions: questions)
            
            self?.mediator.updateData(for: topic) { [weak self] result in
                switch result {
                
                case .success(_):
                    self?.topic = topic
                    self?.collectionView.deleteItems(at: [index])
                    
                case .failure(let error):
                    Alert.errorAlert(error: error)
                }
            }
        }
    }
    
    private func editQuestionAction(at index: IndexPath) -> UIAction {
        
        let editImage = UIImage(systemName: "pencil")
        
        return UIAction(title: "Edit question",
                        image: editImage,
                        identifier: nil) { _ in
            self.performSegue(withIdentifier: "EditQuestion", sender: index)
        }
    }
}
