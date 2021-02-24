//
//  TopicsCell.swift
//  EducationDiary
//
//  Created by Eugene St on 23.02.2021.
//

import UIKit

class TopicCell: UITableViewCell {
    
    @IBOutlet weak var statusView: UIView!
//        didSet {
////            self.layer.cornerRadius = self.frame.size.width / 2
//        }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        statusView.layer.cornerRadius = statusView.frame.size.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureFor(topicModel: TopicViewModel) {
        
        textLabel?.text = topicModel.topic.title
        detailTextLabel?.text = topicModel.topic.status
        
        switch topicModel.topic.status {
        case TopicStatus.done.rawValue: topicModel.textColor = TopicStatus.done.associatedColor
        case TopicStatus.inProgress.rawValue: topicModel.textColor = TopicStatus.inProgress.associatedColor
        case TopicStatus.onHold.rawValue: topicModel.textColor = TopicStatus.onHold.associatedColor
        default: break
        }
        
//        detailTextLabel?.textColor = topicModel.textColor
        statusView.backgroundColor = topicModel.textColor
        
        
    }
}
