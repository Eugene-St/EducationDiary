//
//  BookmarksCell.swift
//  EducationDiary
//
//  Created by Eugene St on 03.02.2021.
//

import UIKit

class BookmarksCell: UITableViewCell {
    
    @IBOutlet weak var copyToClipboardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        copyToClipboardView.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // copy text to clipboard or open in Safari if the link is valid
        if selected {
            if let text = self.detailTextLabel?.text {
                if let url = URL(string: text) {
                    UIApplication.shared.open(url)
                }
                UIPasteboard.general.string = text
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                UIView.transition(with: copyToClipboardView, duration: 0.5, options: .transitionFlipFromTop) {
                    self.copyToClipboardView.isHidden = false
                } completion: { _ in
                    self.copyToClipboardView.isHidden = true
                }
            }
        }
    }
    
    func configure(with bookmarkModel: BookmarkViewModel) {
        self.textLabel?.text = bookmarkModel.bookmark.name
        self.detailTextLabel?.text = bookmarkModel.bookmark.text
    }
}
