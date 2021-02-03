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
    
    // MARK: - View DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.getRequest(of: Topics.self,
                                         path: "topics.json") { result in
            
            switch result {
            case .failure(let error):
                    if error is DataError {
                        print(error)
                    } else {
                        print(error.localizedDescription)
                    }
                    print(error.localizedDescription)
                    
                case .success(let topics):
                    DispatchQueue.main.async {
                        self.topics = topics
                        self.tableView.reloadData()
                }
            }
        }
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
}
