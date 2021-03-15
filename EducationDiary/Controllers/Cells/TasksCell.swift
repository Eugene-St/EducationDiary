//
//  TasksCell.swift
//  EducationDiary
//
//  Created by Eugene St on 11.02.2021.
//

import UIKit

class TasksCell: UITableViewCell {
    
    @IBOutlet weak var progressView: UIView!
    
    private var progressWidth: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        progressView.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        addConstraintsToProgressView()
        textLabel?.numberOfLines = 0
    }
    
    func configure(with taskViewModel: TaskViewModel) {
        
        if taskViewModel.task.progress == 100 {
            progressView.backgroundColor = nil
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
        
        let multiplier = CGFloat(taskViewModel.task.progress ?? 0) / CGFloat(100)
        progressWidth?.isActive = false
        
        progressWidth = progressView.widthAnchor.constraint(equalTo: contentView.widthAnchor,
                                                            multiplier: multiplier)
        progressWidth?.isActive = true
        
        UIView.animate(withDuration: 1.5) {
            self.progressView.superview?.layoutIfNeeded()
        }
    }
    
    private func addConstraintsToProgressView() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        let initialWidth = 1 / 100 * contentView.bounds.width
        progressView.frame.size.width = 0
        progressWidth = progressView.widthAnchor.constraint(equalToConstant: initialWidth)
        progressWidth?.isActive = true
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: contentView.topAnchor),
            progressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            progressView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
    }
}
