//
//  TopicsCell.swift
//  EducationDiary
//
//  Created by Eugene St on 23.02.2021.
//

import UIKit

class TopicCell: UITableViewCell {
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureFor(topicModel: TopicViewModel) {
        
        textLabel?.text = topicModel.topic.title
        detailTextLabel?.text = topicModel.topic.status
    }
}
