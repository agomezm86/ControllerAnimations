//
//  AppsTableViewCell.swift
//  ControllerAnimations
//
//  Created by Field Service on 3/16/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

import UIKit

class AppsTableViewCell: UITableViewCell {

    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var appDescriptionLabel: UILabel!
    @IBOutlet weak var appImageView: UIImageView!
    
    /**
     Carga nib en memoria
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        
        appImageView.layer.cornerRadius = 40.0
        appImageView.clipsToBounds = true
    }
}
