//
//  ImageViewController.swift
//  Networking_Swiftbook
//
//  Created by Eugene St on 19.01.2021.
//

import UIKit

class ImageViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
        }
    }
    @IBOutlet weak var loadingImageLabel: UILabel!
    
    // MARK: - Private Properties
    private var image: UIImage? {
        get {
            imageView.image
        }
        set {
            DispatchQueue.main.async {
                self.imageView.image = newValue
                self.activityIndicator.stopAnimating()
                self.loadingImageLabel.text = ""
            }
            
        }
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        print(activityIndicator.isAnimating)
        fetchImage()
        
    }
    
    // MARK: - Private Methods
    private func fetchImage() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        let path = "https://i.ytimg.com/vi/AqF2hi7f4Hw/maxresdefault.jpg"
        guard let url = URL(string: path) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            if let data = data, let image = UIImage(data: data) {
                    self.image = image
            }
        }.resume()
    }
}
