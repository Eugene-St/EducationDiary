//
//  ToDoCell.swift
//  TodoMaker
//
//  Created by Eugene St on 26.01.2021.
//

import UIKit

class ToDoCell: UITableViewCell {

    @IBOutlet weak var todoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        self.accessoryType = selected ? .checkmark : .none
    }
}
