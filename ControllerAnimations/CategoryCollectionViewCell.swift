//
//  CategoryCollectionViewCell.swift
//  ControllerAnimations
//
//  Created by Alejandro Gomez Mutis on 3/18/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryBackgroundImage: UIView!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    
    /**
     Carga nib en memoria
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        
        categoryBackgroundImage.layer.cornerRadius = 80.0
        categoryBackgroundImage.clipsToBounds = true        
    }
}
