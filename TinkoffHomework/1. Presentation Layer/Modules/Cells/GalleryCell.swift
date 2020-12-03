//
//  GalleryCell.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 17.11.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit

class GalleryCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    var downloadTask: URLSessionDownloadTask?
    
    override func awakeFromNib() {
        
        self.backgroundColor = UIColor(red: 223.0 / 255.0, green: 223.0 / 255.0, blue: 223.0 / 255.0, alpha: 1.0)
        super.awakeFromNib()
   }
   
   override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
   }
    
    func configure(imageURL: String?) {
        downloadTask = imageView.loadImage(urlString: imageURL)
    }
    
    func getImage() -> UIImage? {
        return imageView.image
    }
}
