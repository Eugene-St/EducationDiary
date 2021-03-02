//
//  QuestionsViewController+ContextMenuExtension.swift
//  EducationDiary
//
//  Created by Eugene St on 02.03.2021.
//

import UIKit

extension QuestionsViewController: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(
              identifier: nil,
              previewProvider: nil,
              actionProvider: { _ in
                let removeQuestion = self.makeRemoveQuestionAction()
                let editQuestion = self.editQuestionAction()
                let doneQuestion = self.markAsCompletedQuestionAction()
                let children = [removeQuestion, editQuestion, doneQuestion]
                return UIMenu(title: "", children: children)
            })
    }
    
    private func makeRemoveQuestionAction() -> UIAction {
        
      let removeRatingAttributes = UIMenuElement.Attributes.destructive
        
      let deleteImage = UIImage(systemName: "trash.slash")
        
      return UIAction(
        title: "Remove question",
        image: deleteImage,
        identifier: nil,
        attributes: removeRatingAttributes) { _ in
          print("delete question action pressed")
        }
    }
    
    private func editQuestionAction() -> UIAction {
        
        let editImage = UIImage(systemName: "pencil")
        
        return UIAction(title: "Edit question",
                        image: editImage,
                        identifier: nil) { _ in
            print("edit question action pressed")
        }
    }
    
    private func markAsCompletedQuestionAction() -> UIAction {
        
        let editImage = UIImage(systemName: "checkmark")
        
        return UIAction(title: "Mark as Done",
                        image: editImage,
                        identifier: nil) { _ in
            print("done question action pressed")
        }
    }
    
}
