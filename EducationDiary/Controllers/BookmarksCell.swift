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
    
    func configure(with bookmarks: Bookmarks, indexPath: IndexPath) {
        
        let bookmarkKeys = Array(bookmarks.keys)
        let bookmark = bookmarks[bookmarkKeys[indexPath.row]]

        self.textLabel?.text = bookmark?.name
        self.detailTextLabel?.text = bookmark?.text
        
//        bookmarks.forEach { id, bookmark in
//
//            if bookmark.name == "" {
//                self.detailTextLabel?.font = UIFont.systemFont(ofSize: 18)
//            }
//        }
    }
}
