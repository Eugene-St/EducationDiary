//
//  TasksCell.swift
//  EducationDiary
//
//  Created by Eugene St on 11.02.2021.
//

import UIKit

class TasksCell: UITableViewCell {

//    var upperView: Any?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        upperView = self.superview as! UITableView
//        let tableView = upperView as! UITableView

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with tasks: Tasks, indexPath: IndexPath) {
        
        let taskKeys = Array(tasks.keys)
        let task = tasks[taskKeys[indexPath.row]]

        if task?.progress == 100 {
            
            self.textLabel?.attributedText = task?.description?.strikeThrough()
            self.accessoryType = .checkmark
            self.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        
        } else {
            self.textLabel?.text = task?.description
        }
    }    
}
