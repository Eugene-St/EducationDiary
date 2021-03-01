//
//  SortTopicsPopoverVC.swift
//  EducationDiary
//
//  Created by Eugene St on 28.02.2021.
//

import UIKit

class SortTopicsPopoverVC: UITableViewController {
    
    let sortOptions = [
        "Created date",
        "Due date",
        "Status",
        "Name"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isScrollEnabled = false
        
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortOptions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "sortTopicCell", for: indexPath)
        
        cell.textLabel?.text = sortOptions[indexPath.row]
        
        return cell
    }
}
