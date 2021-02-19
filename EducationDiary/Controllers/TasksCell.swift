//
//  TasksCell.swift
//  EducationDiary
//
//  Created by Eugene St on 11.02.2021.
//

import UIKit

class TasksCell: UITableViewCell {
    
    @IBOutlet weak var progressView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        progressView.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        progressView.frame.size.width = 1
        progressView.frame.size.height = self.frame.height
//        addConstraintsToProgressView()
    }
    
    func configure(with taskViewModel: TaskViewModel) {
        
        print("triggered")

        if taskViewModel.task.progress == 100 {
            progressView.backgroundColor = .clear
            textLabel?.attributedText = taskViewModel.task.description?.strikeThrough()
            taskViewModel.accessoryType = .checkmark
            taskViewModel.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            accessoryType = taskViewModel.accessoryType
            tintColor = taskViewModel.tintColor
            
        } else if taskViewModel.task.progress == nil {
            progressView.backgroundColor = nil
            textLabel?.attributedText = taskViewModel.task.description?.regular()
            accessoryType = .none
            
        } else {
            progressView.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            textLabel?.attributedText = taskViewModel.task.description?.regular()
            accessoryType = .none
        }
        
//        let multiplier = CGFloat(taskViewModel.task.progress ?? 0) / CGFloat(100)
//
//        progressView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: multiplier).isActive = true
//
//        UIView.animate(withDuration: 1.5) {
//            self.progressView.layoutIfNeeded()
//        }
        
        let fullWidth: CGFloat = contentView.bounds.width
        print(fullWidth)
        
        let newWidth = CGFloat(taskViewModel.task.progress ?? 0) / 100 * fullWidth
        
        UIView.animate(withDuration: 1.5) {
            self.progressView.frame.size = CGSize(width: newWidth, height: self.frame.height)
        }

    }
    
    private func addConstraintsToProgressView() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        let initialWidth = 1 / 100 * contentView.bounds.width
        progressView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        progressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        progressView.widthAnchor.constraint(equalToConstant: initialWidth).isActive = true
    }
}
