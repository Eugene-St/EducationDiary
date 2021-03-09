//
//  BookmarksViewController.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import UIKit

class BookmarksViewController: UITableViewController {
    
    // MARK: - Private Properties
    var bookmarksViewModel = [BookmarkViewModel]()
    lazy var mediator = BookmarksMediator()
    
    // MARK: - View DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add long press gesture
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        self.tableView.addGestureRecognizer(longPressRecognizer)
        
        loadData()
    }
    
    // MARK: - Table view data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bookmarksViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell", for: indexPath) as! BookmarksCell
        
        cell.configure(with: bookmarksViewModel[indexPath.row])
        
        return cell
    }
    
    // MARK: - Table View Delegate method
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let bookmarkViewModel = bookmarksViewModel[indexPath.row]
            
            mediator.deleteData(for: bookmarkViewModel.bookmark) { result in
                switch result {
                
                case .success(_):
                    self.bookmarksViewModel.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    
                case .failure(let error):
                    print("No internet!", error)
                    Alert.errorAlert(error: error)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - IBActions
    @IBAction func addBookmarkPressed(_ sender: UIBarButtonItem) {
        showAddAlertController()
    }
    
    // MARK: - Private methods
    @objc private func longPressed(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizer.State.began {
            
            let touchPoint = sender.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                
                let bookmarkViewModel = bookmarksViewModel[indexPath.row]
                
                showEditAlertController(for: bookmarkViewModel)
            }
        }
    }
    
    private func showAddAlertController() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        showAlert(title: "Add bookmark", message: "Please enter Bookmark name and text")
    }
    
    private func showEditAlertController(for bookmarkModel: BookmarkViewModel) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        showAlert(title: "Edit bookmark", message: "You may edit the bookmark", bookmark: bookmarkModel.bookmark)
    }
    
    private func loadData() {
        
        mediator.fetchData({ result in
            switch result {
            
            case .success(let bookmarks):
                bookmarks.forEach { [weak self] key, bookmark in
                    self?.bookmarksViewModel.append(BookmarkViewModel(bookmark: bookmark, key: key))
                }
                self.tableView.reloadData()
                
            case .failure(let error):
                print("BookmarksInteractor ERROR:\(error.localizedDescription)")
                Alert.errorAlert(error: error)
            }
        })
    }
}
