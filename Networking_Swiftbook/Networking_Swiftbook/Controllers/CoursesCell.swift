//
//  CoursesCell.swift
//  Networking_Swiftbook
//
//  Created by Eugene St on 20.01.2021.
//

import UIKit

class CoursesCell: UITableViewCell {
    
    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var numberOfLessonsLabel: UILabel!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var numberOfTests: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
        }
    }
    
    func configureCell(for course: Course) {
        
        activityIndicator.startAnimating()
        courseNameLabel.text = course.name
        numberOfLessonsLabel.text = "Number of Lessons: \(course.numberOfLessons ?? 0)"
        numberOfTests.text = "Number of Tests: \(course.numberOfTests ?? 0)"
        
        DispatchQueue.global().async {
            guard let imageURL = URL(string: course.imageUrl ?? "") else { return }
            guard let data = try? Data(contentsOf: imageURL) else { return }
            
            DispatchQueue.main.async {
                self.courseImage.image = UIImage(data: data)
                self.activityIndicator.stopAnimating()
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
