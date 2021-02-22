//
//  TopicsViewController.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import UIKit

class TopicsViewController: UITableViewController {
    
    // MARK: - Private Properties
    private var topics = Topics()
    private lazy var mediator = TopicsMediator()
    
    // MARK: - View DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        topics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topicCell", for: indexPath)
        
        let topicKeys = Array(topics.keys)
        let topic = topics[topicKeys[indexPath.row]]
        
        cell.textLabel?.text = topic?.title
        cell.detailTextLabel?.text = topic?.status
        
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
    
    
    // MARK: - Private methods
    private func loadData() {
        mediator.fetchData { result in
            switch result {
            
            case .success(let topics):
                self.topics = topics
                self.tableView.reloadData()
            case .failure(let error):
                print("TopicsMediator ERROR:\(error.localizedDescription)")
            }
        }
    }
}
