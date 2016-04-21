//
//  AppsCollectionViewCell.swift
//  ControllerAnimations
//
//  Created by Alejandro Gomez Mutis on 3/18/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

import UIKit

class AppsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appSummary: UILabel!
    
    /**
     Carga nib en memoria
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        
        appImageView.layer.cornerRadius = 75.0
        appImageView.clipsToBounds = true
    }
    
}
