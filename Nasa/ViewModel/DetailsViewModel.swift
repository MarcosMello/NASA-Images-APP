import UIKit

struct DetailsViewModel {
    let galleryTableViewCell: GalleryTableViewCell?
    
    init(with galleryTableViewCell: GalleryTableViewCell?) {
        self.galleryTableViewCell = galleryTableViewCell
    }
    
    var imageTitle: String? {
        return galleryTableViewCell?.descriptionLabel.text
    }
    
    var image: UIImage? {
        return galleryTableViewCell?.marsRoverImageView.image
    }
}
