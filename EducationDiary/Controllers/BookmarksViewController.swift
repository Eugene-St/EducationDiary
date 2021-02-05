//
//  BookmarksViewController.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import UIKit

class BookmarksViewController: UITableViewController {
    
    // todo: move alert controller to a separate file/class
    // todo: UX
    // todo: Delete request call from mediator
    
    // MARK: - Private Properties
    var bookmarks = Bookmarks()
    private var mediator: BookmarksMediator?
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add long press gesture
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        self.tableView.addGestureRecognizer(longPressRecognizer)
        
        mediator = BookmarksMediator()
        
        mediator?.fetchData({ result in
            switch result {
            case .success(let bookmarks):
                self.bookmarks = bookmarks
                self.tableView.reloadData()
            case .failure(let error):
                print("BookmarksInteractor ERROR:\(error.localizedDescription)")
            }
        })
    }
    
    // MARK: - Table view data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bookmarks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell", for: indexPath) as! BookmarksCell
        
        cell.configure(with: bookmarks, indexPath: indexPath)
        
        return cell
    }
    
    // MARK: - Table View Delegate method
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let bookmarkKeys = Array(bookmarks.keys)
            let bookMarKey = bookmarkKeys[indexPath.row]
            let bookMArkID = "\(bookMarKey).json"
            
            mediator?.deleteData(with: bookMArkID, { result in
                switch result {
                
                case .success(_):
                        self.bookmarks.removeValue(forKey: bookmarkKeys[indexPath.row])
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                
                case .failure(let error):
                    let ac = UIAlertController(title: "No network connection", message: "We cannot delete the record, re-check internet, \(error)", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default)
                    ac.addAction(okAction)
                    self.present(ac, animated: true)
                }
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - IBActions
    @IBAction func addBookmarkPressed(_ sender: UIBarButtonItem) {
        addAlertController()
    }
    
    // MARK: - Private methods
    @objc private func longPressed(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizer.State.began {
            
            let touchPoint = sender.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                
                let cell = tableView.cellForRow(at: indexPath)
                
                print("Long pressed row: \(cell?.detailTextLabel?.text ?? "No details")")
                
                editAlertController(with: cell?.textLabel?.text,
                                    and: cell?.detailTextLabel?.text)
            }
        }
    }
    
    private func addAlertController() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        Alert.showAlert(title: "Add bookmark", message: "Please enter Bookmark name and text", on: self, mediator: mediator)
    }
    
    private func editAlertController(with name: String?, and text: String?) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        Alert.showAlert(title: "Edit bookmark", message: "You may edit the bookmark", on: self, mediator: mediator, name: name, text: text)
    }
}
