//
//  CategoryTableViewCell.swift
//  ControllerAnimations
//
//  Created by Field Service on 3/16/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    /**
     Carga nib en memoria
     */
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
