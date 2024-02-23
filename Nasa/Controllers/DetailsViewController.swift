//
//  DetailsViewController.swift
//  Nasa
//
//  Created by Marcos Vinicius Vargas Mello on 21/02/24.
//

import UIKit

class DetailsViewController: UIViewController {
    var imageTitle: String?
    var image: UIImage?
    
    @IBOutlet weak var titleUILabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleUILabel.text = imageTitle
        imageView.image = image
    }
}
