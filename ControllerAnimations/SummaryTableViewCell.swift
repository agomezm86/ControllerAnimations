//
//  SummaryTableViewCell.swift
//  ControllerAnimations
//
//  Created by Field Service on 3/17/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var appSummary: UILabel!
    @IBOutlet weak var appPrice: UILabel!
    @IBOutlet weak var appReleaseDate: UILabel!
    @IBOutlet weak var appRights: UILabel!
    
    @IBOutlet weak var summaryHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var summaryWidthConstraint: NSLayoutConstraint!
    
    /**
     Carga nib en memoria
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .None
        
        if (Constants.isIphone) {
            appImageView.layer.cornerRadius = 60.0
        } else {
            appImageView.layer.cornerRadius = 125.0
        }
        appImageView.clipsToBounds = true
    }
}
