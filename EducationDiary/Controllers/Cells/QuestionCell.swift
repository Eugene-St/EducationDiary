//
//  QuestionCell.swift
//  EducationDiary
//
//  Created by Eugene St on 01.03.2021.
//

import UIKit

class QuestionCell: UICollectionViewCell {
    
    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var answerTextLabel: UILabel!
    @IBOutlet weak var checkmarkTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = #colorLiteral(red: 0.8064897656, green: 0.7222248912, blue: 0.5682157874, alpha: 1)
        contentView.layer.cornerRadius = 6
        contentView.layer.masksToBounds = true
        layer.cornerRadius = 6
    }
    
    func configure(for question: Question?) {
        
        questionTextLabel.text = "Question: " + (question?.text ?? "")
        answerTextLabel.text = "Answer: " + (question?.answer ?? "")
        checkmarkTextLabel.text = "✔"
        checkmarkTextLabel.textColor = .green
        
        guard let done = question?.done else { return }
        
        checkmarkTextLabel.isHidden = done ? false : true
    }
}
