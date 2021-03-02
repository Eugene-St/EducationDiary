//
//  TopicsViewController.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import UIKit

class TopicsViewController: UITableViewController {
    
    // MARK: - Private Properties
//    private var topics = Topics()
    private lazy var mediator = TopicsMediator()
    var topicViewModels = [TopicViewModel]()
    
    // MARK: - View DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        topicViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "topicCell", for: indexPath) as! TopicCell
        
        cell.configureWith(topicModel: topicViewModels[indexPath.row])
        
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let topic = topicViewModels[indexPath.row].topic
            
            mediator.deleteData(for: topic) { [weak self] result in
                switch result {
                
                case .success(_):
                    self?.topicViewModels.remove(at: indexPath.row)
                    self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                    
                case .failure(let error):
                    print("Deletion error", error)
                    Alert.errorAlert(error: error)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "TopicDetails", sender: indexPath)
    }
    
    // MARK: - IBActions
    @IBAction func addTopicPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddNewTopic", sender: nil)
        
    }
    
    @IBAction func sortButtonPressed(_ sender: UIBarButtonItem) {
        showSortAlert()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "AddNewTopic":
            guard let vc = segue.destination as? TopicEditCreateViewController else { return }
            vc.title = "Add new Topic"
            

            vc.onCompletionFromEditVC = { [weak self] topicViewModel in
                self?.topicViewModels.insert(topicViewModel, at: 0)
                self?.tableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .automatic)
            }
            
            
        case "TopicDetails":
            guard let vc = segue.destination as? TopicDetailsViewController else { return }
            guard let indexpath = sender as? IndexPath else { return }
            let topicViewModel = topicViewModels[indexpath.row]
            vc.title = topicViewModel.topic.title
            vc.topicViewModel = topicViewModel
            
            vc.onCompletionFromDetailsVC = { [weak self] topicViewModel in
                
                if let index = self?.topicViewModels.firstIndex(where: { $0.key == topicViewModel.topic.id }) {
                    self?.topicViewModels[index] = topicViewModel
                    self?.tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
                }
            }
        default:
            break
        }
    }
    
    // MARK: - Private methods
    private func loadData() {
        
        mediator.fetchData { [weak self] result in
            switch result {
            
            case .success(let topics):
                topics.forEach { key, topic in
                    self?.topicViewModels.append(TopicViewModel(topic: topic, key: key))
                }
                self?.tableView.reloadData()
                
            case .failure(let error):
                    Alert.errorAlert(error: error)
                    print("TopicsMediator ERROR:\(error.localizedDescription)")
            }
        }
    }
}

extension TopicsViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
}
