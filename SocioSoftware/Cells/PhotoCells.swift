//
//  PhotoCells.swift
//  SocioSoftware
//
//  Created by George Digmelashvili on 9/21/21.
//

import UIKit

class PhotoCells: UICollectionViewCell {
    
    static let identifier = "PhotoCells"
    
    @IBOutlet weak var imageView: UIImageView!
    
    var photo: PhotoViewModel!{
        didSet{
            if let imgUrl = photo.imgUrl{
                imgUrl.downloadImage { img in
                    self.imageView.image = img
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
