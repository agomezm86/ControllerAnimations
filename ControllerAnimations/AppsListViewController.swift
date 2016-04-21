//
//  AppsListViewController.swift
//  ControllerAnimations
//
//  Created by Alejandro Gomez Mutis on 3/16/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

import UIKit

class AppsListViewController: UIViewController {
    
    /**
     Outlets
     */
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var applicationsLogic: ApplicationsLogic = ApplicationsLogic()
    
    var applicationsArray = NSArray()
    var category: String = ""
    let fileManager = NSFileManager()
    let documentDirectoryPath: String = Constants.getDocumentsDirectory()
    
    /**
     Animaciones
     */
    private let flipPresentControllerAnimator = FlipPresentControllerAnimator()
    private let flipDismissControllerAnimator = FlipDismissControllerAnimator()
    
    private let flipControllerIpadAnimator = FlipControllerIpadAnimator()
    
    /**
     Carga la vista
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = category
        
        let nib = UINib(nibName: Constants.appsTableCell, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: Constants.appsTableCell)
        
        let nib1 = UINib(nibName: Constants.appsCollectionCell, bundle: nil)
        self.collectionView.registerNib(nib1, forCellWithReuseIdentifier: Constants.appsCollectionCell)
        
        applicationsArray = applicationsLogic.getApplicationsByCategory(category)
    }
    
    /**
     Presentación de nuevo segue
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.summarySegueId {
            var row: Int = 0
            if (Constants.isIphone) {
                let indexPath = self.tableView.indexPathForSelectedRow!
                row = (self.tableView.indexPathForSelectedRow?.row)!
                self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
            } else {
                let indexPath = sender as! NSIndexPath
                row = indexPath.item
            }
            
            let application: Applications = self.applicationsArray[row] as! Applications
            
            let controller: SummaryViewController = segue.destinationViewController as! SummaryViewController
            controller.transitioningDelegate = self
            controller.application.name = application.name
            controller.application.summary = application.summary
            controller.application.image = application.image
            controller.application.amount = application.amount
            controller.application.currency = application.currency
            controller.application.rights = application.rights
            controller.application.releaseDate = application.releaseDate
        }
    }

    /**
     Volver a la lista de categorias
     */
    @IBAction func backButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension AppsListViewController: UITableViewDataSource {
    
    /**
     Número de filas de la tabla
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.applicationsArray.count
    }
    
    /**
     Celdas de la tabla
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: AppsTableViewCell = tableView.dequeueReusableCellWithIdentifier(Constants.appsTableCell) as! AppsTableViewCell
        let row = indexPath.row
        
        let application: Applications = self.applicationsArray[row] as! Applications
        cell.appNameLabel.text = application.name
        cell.appDescriptionLabel.text = application.summary
        
        let destinationURLForFile = NSURL(fileURLWithPath: documentDirectoryPath.stringByAppendingFormat("/%@.png", application.name!))
        if fileManager.fileExistsAtPath(destinationURLForFile.path!){
            cell.appImageView.image = UIImage(data: NSData(contentsOfURL: destinationURLForFile)!)
        }

        return cell
    }
}

extension AppsListViewController: UITableViewDelegate {
    
    /**
     Se selecciona una fila de la tabla
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(Constants.summarySegueId, sender: nil)
    }
    
    /**
     Altura de cada celda de la tabla
     */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
}

extension AppsListViewController: UICollectionViewDataSource {

    /**
     Número de items de la colección
     */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return applicationsArray.count
    }
    
    /**
     Celdas de la colección
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: AppsCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.appsCollectionCell, forIndexPath: indexPath) as! AppsCollectionViewCell
        let item: Int = indexPath.item
        let application: Applications = self.applicationsArray[item] as! Applications
        cell.appName.text = application.name
        cell.appSummary.text = application.summary
        
        let destinationURLForFile = NSURL(fileURLWithPath: documentDirectoryPath.stringByAppendingFormat("/%@.png", application.name!))
        if fileManager.fileExistsAtPath(destinationURLForFile.path!){
            cell.appImageView.image = UIImage(data: NSData(contentsOfURL: destinationURLForFile)!)
        }
        
        return cell
    }
}

extension AppsListViewController: UICollectionViewDelegate {
    
    /**
     Se selecciona un item de la colección
     */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(Constants.summarySegueId, sender: indexPath)
    }
    
}

extension AppsListViewController: UICollectionViewDelegateFlowLayout {
    
    /**
     Tamaño de cada item de la colección
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (self.view.bounds.size.width / 2) - 10
        return CGSize(width: width, height: 230)
    }
}

extension AppsListViewController: UIViewControllerTransitioningDelegate {
    
    /**
     Presentacion de controladores
     */
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if (Constants.isIphone) {
            flipPresentControllerAnimator.originFrame = self.view.frame
            return flipPresentControllerAnimator
        } else {
            flipControllerIpadAnimator.reverse = true
            return flipControllerIpadAnimator
        }
    }
    
    /**
     Presentacion de controladores
     */
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if (Constants.isIphone) {
            flipDismissControllerAnimator.destinationFrame = self.view.frame
            return flipDismissControllerAnimator
        } else {
            flipControllerIpadAnimator.reverse = false
            return flipControllerIpadAnimator
        }
    }
}

