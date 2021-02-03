//
//  BookmarksCell.swift
//  EducationDiary
//
//  Created by Eugene St on 03.02.2021.
//

import UIKit

class BookmarksCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
