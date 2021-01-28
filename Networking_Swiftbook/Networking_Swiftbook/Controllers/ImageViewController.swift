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
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage()
    }
    
    private func fetchImage() {
        
        activityIndicator.startAnimating()
        
        NetworkManager.downloadImage { (image) in
            
            self.activityIndicator.stopAnimating()
            self.loadingImageLabel.text = ""
            self.imageView.image = image
        }
    }
}
