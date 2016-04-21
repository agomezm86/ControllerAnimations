//
//  SummaryViewController.swift
//  ControllerAnimations
//
//  Created by Field Service on 3/16/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {
    
    var application: ApplicationsModel = ApplicationsModel(newId: 0, newCategory: "", newName: "", newSummary: "", newImage: "", newAmount: "", newCurrency: "", newRights: "", newReleaseDate: "")
    
    /**
     Outlets
     */
    @IBOutlet weak var tableView: UITableView!
    
    let fileManager = NSFileManager()
    let documentDirectoryPath: String = Constants.getDocumentsDirectory()
    
    var height: CGFloat = 0.0
    
    /**
     Carga la vista
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .None
        let summaryNib = UINib(nibName: Constants.summaryTableCell, bundle: nil)
        tableView.registerNib(summaryNib, forCellReuseIdentifier: Constants.summaryTableCell)
    }
    
    /**
     Despues de la presentación de la vista
     */
    override func viewDidAppear(animated: Bool) {
        let indexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        let cell: SummaryTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! SummaryTableViewCell
        if (Constants.isIphone) {
            height = 150.0 + cell.appSummary.frame.size.height
        } else {
            height = 730.0 + cell.appSummary.frame.size.height
        }
        tableView.reloadData()
    }

    /**
     Volver a la lista de aplicaciones
     */
    @IBAction func backButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     Altura de la vista de resumen
     */
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
}

extension SummaryViewController: UITableViewDataSource {
    
    /**
     Número de filas de la tabla
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    /**
     Celdas de la tabla
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: SummaryTableViewCell = tableView.dequeueReusableCellWithIdentifier(Constants.summaryTableCell) as! SummaryTableViewCell
        
        cell.appTitle.text = application.name
        cell.appSummary.text = application.summary
        
        let destinationURLForFile = NSURL(fileURLWithPath: documentDirectoryPath.stringByAppendingFormat("/%@.png", application.name!))
        if fileManager.fileExistsAtPath(destinationURLForFile.path!){
            cell.appImageView.image = UIImage(data: NSData(contentsOfURL: destinationURLForFile)!)
        }
        
        cell.appPrice.text = NSString(format: "%@ %@", application.amount!, application.currency!) as String
        cell.appReleaseDate.text = application.releaseDate
        cell.appRights.text = application.rights
        
        let font: UIFont = cell.appSummary.font
        let width: CGFloat = self.view.frame.size.width - 20
        cell.summaryWidthConstraint.constant = width
        
        let height: CGFloat = heightForView(application.summary!, font: font, width: width)
        cell.summaryHeightConstraint.constant = height
        
        return cell
    }
}

extension SummaryViewController: UITableViewDelegate {
    
    /**
     Altura de cada celda de la tabla
     */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return height
    }
}
