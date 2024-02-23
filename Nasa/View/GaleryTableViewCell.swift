//
//  GaleryTableViewCell.swift
//  Nasa
//
//  Created by Marcos Vinicius Vargas Mello on 23/02/24.
//

import UIKit

class GaleryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var marsRoverImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}