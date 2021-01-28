//
//  BookmarksViewController.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import UIKit

class BookmarksViewController: UITableViewController {

    // MARK: - Private Properties
    private var bookmarks = [String: Bookmark]()
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.fetchData { booksmark in
            DispatchQueue.main.async {
                self.bookmarks = booksmark
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bookmarks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell", for: indexPath)
        
        let bookmarkValues = Array(bookmarks.values)

        cell.textLabel?.text = bookmarkValues[indexPath.row].name
        cell.detailTextLabel?.text = bookmarkValues[indexPath.row].text

        return cell
    }

    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
//            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            print("Edited")
        }    
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - IBActions
    @IBAction func addBookmarkPressed(_ sender: UIBarButtonItem) {
        
        let ac = UIAlertController(title: "Add bookmark", message: "Please enter bookmark name and text", preferredStyle: .alert)
        
        ac.addTextField { nameTextfield in
            nameTextfield.placeholder = "name - optional"
        }
        
        ac.addTextField { textField in
            textField.placeholder = "text - required"
        }
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            print("added new bookmark")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        ac.addAction(cancelAction)
        ac.addAction(okAction)
        
        present(ac, animated: true)
    }
    
    
    // MARK: - Private methods

}
