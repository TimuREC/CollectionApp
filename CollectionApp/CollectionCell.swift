//
//  CollectionCell.swift
//  CollectionApp
//
//  Created by Timur Begishev on 13.01.2021.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    
    func configure(with image: UIImage) {
        self.imageView.image = image
    }

}
