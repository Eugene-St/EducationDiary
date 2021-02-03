//
//  BookmarksCell.swift
//  EducationDiary
//
//  Created by Eugene St on 03.02.2021.
//

import UIKit

class BookmarksCell: UITableViewCell {
    
    // todo:
    // logic to copy text to clipboard / open in safari if link is valid
    
    // long tap to edit
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            if let text = self.detailTextLabel?.text {
                if let url = URL(string: text) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }

    func configure(with bookmarks: Bookmarks, indexPath: IndexPath) {
        let bookmarkKeys = Array(bookmarks.keys)
        let bookmark = bookmarks[bookmarkKeys[indexPath.row]]

        self.textLabel?.text = bookmark?.name
        self.detailTextLabel?.text = bookmark?.text
        
        UIPasteboard.general.string = bookmark?.text
    }
}
