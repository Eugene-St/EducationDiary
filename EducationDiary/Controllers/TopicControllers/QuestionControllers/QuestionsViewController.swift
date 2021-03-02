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

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        questions.count
        topic?.questions?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
        
        cell.configure(for: topic?.questions?[indexPath.item])
//        cell.configure(for: questions[indexPath.item])
    
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
                
//                self?.questions.insert(question, at: 0)
//                self?.collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
                self?.topic? = topic
                self?.collectionView.reloadData()
            }
            
        case "EditQuestion":
            print("Edit question")
       
        default:
            break
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension QuestionsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsPerRow: CGFloat = 2
        
        let paddingWidth = 20 * (itemsPerRow + 1)
        
        let availableWidth = collectionView.frame.width - paddingWidth
        
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem * 1.5)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
}
 

