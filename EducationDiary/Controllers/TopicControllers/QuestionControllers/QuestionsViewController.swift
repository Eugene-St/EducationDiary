//
//  QuestionsViewController.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import UIKit

class QuestionsViewController: UICollectionViewController {
    
    var topic: Topic?
    var onCompletionFromQuestionsVC: ((_ topic: Topic?) -> ())?
    var interaction: UIContextMenuInteraction?
    lazy var mediator = TopicsMediator()

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = CollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        
        collectionView.collectionViewLayout = layout
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        topic?.questions?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
        
        cell.configure(for: topic?.questions?[indexPath.item])
    
        return cell
    }
    
    // MARK: - IBActions
    @IBAction func addNewQuestionButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddNewQuestion", sender: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        onCompletionFromQuestionsVC?(topic)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        
        case "AddNewQuestion":
            guard let vc = segue.destination as? QuestionEditCreateViewController else { return }
            vc.title = "Add new question"
            vc.topic = topic
            
            vc.onCompletionFromQuestionDetailsVC = { [weak self] topic in
                
                self?.topic? = topic
                self?.collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
            }
            
        case "EditQuestion":
            guard let vc = segue.destination as? QuestionEditCreateViewController else { return }
            guard let indexPath = sender as? IndexPath else { return }
            let question = topic?.questions?[indexPath.item]
            
            vc.title = "Edit question"
            vc.topic = topic
            vc.question = question
            vc.index = indexPath.item
            
            vc.onCompletionFromQuestionDetailsVC = { [weak self] topic in
                    self?.topic? = topic
                    self?.collectionView.reloadItems(at: [indexPath])
            }
       
        default:
            break
        }
    }
}

// MARK: - CollectionViewWaterfallLayoutDelegate
extension QuestionsViewController: CollectionViewWaterfallLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let itemsPerRow: CGFloat = 2
        
        let paddingWidth = 20 * (itemsPerRow + 1)
        
        let availableWidth = collectionView.frame.width - paddingWidth
        
        let widthPerItem = availableWidth / itemsPerRow
        
        let title = topic?.questions?[indexPath.item].text ?? ""
        let answer = topic?.questions?[indexPath.item].answer ?? ""
        let done = String(topic?.questions?[indexPath.item].done ?? false)
        
        let size = CGSize(width: widthPerItem, height: 1000)
        
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        
        let estimatedTitleFrame = NSString(string: title).boundingRect(
            with: size,
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil)
        
        let estimatedAnswerFrame = NSString(string: answer).boundingRect(
            with: size,
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil)
        
        let estimatedDoneFrame = NSString(string: done).boundingRect(
            with: size,
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil)
        
        return CGSize(width: widthPerItem, height: (estimatedTitleFrame.height + estimatedDoneFrame.height + estimatedAnswerFrame.height) + 14)
        
    }
}
