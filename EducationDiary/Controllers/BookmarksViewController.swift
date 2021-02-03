//
//  BookmarksViewController.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import UIKit

class BookmarksViewController: UITableViewController {

    // MARK: - Private Properties
    private var bookmarks = Bookmarks()
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add long press gesture
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        self.tableView.addGestureRecognizer(longPressRecognizer)
        
        // fetch data from network
        NetworkManager.shared.getRequest(of: Bookmarks.self, path: "bookmarks.json") { result in
            switch result {
            case .failure(let error):
                    if error is DataError {
                        print(error)
                    } else {
                        print(error.localizedDescription)
                    }
                    print(error.localizedDescription)
                    
                case .success(let bookmarks):
                    DispatchQueue.main.async {
                        self.bookmarks = bookmarks
                        self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bookmarks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell", for: indexPath)
        
        let bookmarkKeys = Array(bookmarks.keys)
        let bookmark = bookmarks[bookmarkKeys[indexPath.row]]

        cell.textLabel?.text = bookmark?.name
        cell.detailTextLabel?.text = bookmark?.text
        
        let copyPaste = 0 //
        
        UIPasteboard.general.string = bookmark?.text

        return cell
    }

    // MARK: - Table View Delegate method
    // edit cell
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let bookmarkKeys = Array(bookmarks.keys)
            let bookMarKey = bookmarkKeys[indexPath.row]
            let bookMArkID = "\(bookMarKey).json"
            
            NetworkManager.shared.deleteRequest(path: "bookmarks/", id: bookMArkID) { error in
                if let err = error {
                    print("Failed to delete", err)
                    return
                }
            }
            
            self.bookmarks.removeValue(forKey: bookmarkKeys[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - IBActions
    @IBAction func addBookmarkPressed(_ sender: UIBarButtonItem) {
        
        var dataToPass: [String: String] = [:]
        
        let timeStamp = String(format: "%.0f", Date.timeIntervalSinceReferenceDate)
        let id = "\(timeStamp)"
        
        let ac = UIAlertController(title: "Add bookmark", message: "Please enter Bookmark name and text", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            
            if let name = ac.textFields?.first?.text {
                dataToPass["name"] = name
            }
            
            if let text = ac.textFields?.last?.text {
                dataToPass["text"] = text
            }

            NetworkManager.shared.putRequest(path: "/bookmarks/", id: id, body: dataToPass) { error in
                if let err = error {
                    print("Failed to put", err)
                    return
                }
            }
            
            self.bookmarks[id] = Bookmark(name: dataToPass["name"], text: dataToPass["text"])
            
//            let insertionIndexPath = IndexPath(row: self.bookmarks.count - 1, section: 0)
//            self.tableView.insertRows(at: [insertionIndexPath], with: .automatic)
            
            
            self.tableView.reloadData()
        }
        
        ac.addTextField { nameTextfield in
            nameTextfield.placeholder = "name - optional"
            nameTextfield.autocapitalizationType = .sentences
        }
        
        ac.addTextField { textField in
            textField.placeholder = "text - required"
            textField.autocapitalizationType = .sentences

            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main) { _ in

                let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0

                let textIsNotEmpty = textCount > 0

                okAction.isEnabled = textIsNotEmpty
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

        ac.addAction(cancelAction)
        okAction.isEnabled = false
        ac.addAction(okAction)
        present(ac, animated: true)
    }
    
    // MARK: - Private methods
    @objc func longPressed(sender: UILongPressGestureRecognizer) {

        if sender.state == UIGestureRecognizer.State.began {

            let touchPoint = sender.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {

                let cell = tableView.cellForRow(at: indexPath)

                print("Long pressed row: \(cell?.detailTextLabel?.text ?? "No details")")
            }
        }
    }
}
