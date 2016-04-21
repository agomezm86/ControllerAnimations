//
//  ViewController.swift
//  ControllerAnimations
//
//  Created by Alejandro Gomez Mutis on 3/16/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    /**
     Outlets
     */
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var applicationsLogic: ApplicationsLogic = ApplicationsLogic()
    
    var categoriesArray = NSArray()
    var preventAnimation = Set<NSIndexPath>()
    
    var selectedCell: CategoryTableViewCell?
    
    /**
     Animaciones
     */
    var bounceAnimator = BounceAnimator()
    var presentControllerIpadAnimator = PresentControllerIpadAnimator()
    var dismissControllerIpadAnimator = DismissControllerIpadAnimator()
    
    
    /**
     Carga la vista
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Categories"
        
        let nib = UINib(nibName: Constants.categoryTableCell, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: Constants.categoryTableCell)
        
        let nib1 = UINib(nibName: Constants.categoryCollectionCell, bundle: nil)
        self.collectionView.registerNib(nib1, forCellWithReuseIdentifier: Constants.categoryCollectionCell)
        
        applicationsLogic.getApplicationsInformation({(error) -> Void in
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                dispatch_async(dispatch_get_main_queue()) {
                    // actualización de UI en el hilo principal
                    self.categoriesArray = self.applicationsLogic.getCategories()
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                }
            }
        })
    }
    
    /**
     Antes de la presentación de la vista
     */
    override func viewWillAppear(animated: Bool) {
        self.categoriesArray = self.applicationsLogic.getCategories()
    }
    
    /**
     Presentación de nuevo segue
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.applicationsListSegueId {
            var row = 0
            if (Constants.isIphone) {
                let indexPath = self.tableView.indexPathForSelectedRow!
                selectedCell = self.tableView.cellForRowAtIndexPath(indexPath) as? CategoryTableViewCell
                self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
                row = indexPath.row
            } else {
                let indexPath = sender as! NSIndexPath
                row = indexPath.item
            }
            
            let application: NSDictionary = self.categoriesArray[row] as! NSDictionary
            // nombre de la categoría
            let category = application.valueForKey(Constants.category) as! String
            
            let controller = segue.destinationViewController as! AppsListViewController
            controller.transitioningDelegate = self
            controller.category = category
        }
    }
    
    /** 
     Imagen por categoría
     @param category nombre de la categoría
     */
    
    func getImageForCategory(category: String) -> UIImage {
        var image = UIImage()
        switch category {
            case Enumerations.Categories.Education.rawValue:
                image = UIImage(named: Constants.educationImage)!
            case Enumerations.Categories.Games.rawValue:
                image = UIImage(named: Constants.gamesImage)!
            case Enumerations.Categories.Music.rawValue:
                image = UIImage(named: Constants.musicImage)!
            case Enumerations.Categories.Navigation.rawValue:
                image = UIImage(named: Constants.navigationImage)!
            case Enumerations.Categories.PhotoVideo.rawValue:
                image = UIImage(named: Constants.photoImage)!
            case Enumerations.Categories.Social.rawValue:
                image = UIImage(named: Constants.socialImage)!
            case Enumerations.Categories.Sports.rawValue:
                image = UIImage(named: Constants.sportsImage)!
            case Enumerations.Categories.Travel.rawValue:
                image = UIImage(named: Constants.travelImage)!
            default:
                image = UIImage(named: Constants.unknownImage)!
        }
        
        return image
    }
    
    /**
     Obtiene el color para un indice
     @param index indice
     */
    func colorForIndex(index: Int) -> UIColor {
        let itemCount = categoriesArray.count - 1
        let color = (CGFloat(index) / CGFloat(itemCount)) * 0.8
        return UIColor(red: 1.0, green: color, blue: 0.0, alpha: 1.0)
    }
}

extension CategoriesViewController: UITableViewDataSource {
    
    /**
     Número de filas de la tabla
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoriesArray.count
    }
    
    /**
     Celdas de la tabla
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        let cell: CategoryTableViewCell = tableView.dequeueReusableCellWithIdentifier(Constants.categoryTableCell) as! CategoryTableViewCell
        let application: NSDictionary = self.categoriesArray[row] as! NSDictionary
        let category: String = (application.valueForKey(Constants.category) as? String)!
        cell.categoryLabel?.text = category
        
        return cell
    }
}

extension CategoriesViewController: UITableViewDelegate {
    
    /**
     Se selecciona una fila de la tabla
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(Constants.applicationsListSegueId, sender: nil)
    }
    
    /**
     Se va a mostrar una celda
     */
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (!preventAnimation.contains(indexPath)) {
            preventAnimation.insert(indexPath)
            TableCellAnimator.animateCell(cell)
        }
        cell.backgroundColor = colorForIndex(indexPath.row)
    }
    
    /**
     Altura de cada celda de la tabla
     */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
}

extension CategoriesViewController: UICollectionViewDataSource {
    
    /**
     Número de items de la colección
     */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    /**
     Celdas de la colección
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: CategoryCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.categoryCollectionCell, forIndexPath: indexPath) as! CategoryCollectionViewCell
        
        let item: Int = indexPath.item
        let application: NSDictionary = self.categoriesArray[item] as! NSDictionary
        let category: String = (application.valueForKey(Constants.category) as? String)!
        
        cell.categoryName.text = category
        cell.categoryBackgroundImage.backgroundColor = colorForIndex(item)
        cell.categoryImageView.image = getImageForCategory(category)
        
        return cell
    }
}

extension CategoriesViewController: UICollectionViewDelegate {
    
    /**
     Se selecciona un item de la colección
     */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(Constants.applicationsListSegueId, sender: indexPath)
    }
    
}

extension CategoriesViewController: UICollectionViewDelegateFlowLayout {
    
    /**
     Tamaño de cada item de la colección
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 200, height: 225)
    }
}

extension CategoriesViewController: UIViewControllerTransitioningDelegate {
    
    /**
     Presentacion de controladores
     */
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if (Constants.isIphone) {
            bounceAnimator.presentedControlled = presented
            bounceAnimator.presentingController = presenting
            bounceAnimator.originFrame = selectedCell!.superview!.convertRect(selectedCell!.frame, toView: nil)
            bounceAnimator.presenting = true
            return bounceAnimator
        } else {
            return presentControllerIpadAnimator
        }
    }
    
    /**
     Dismiss de controladores
     */
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if (Constants.isIphone) {
            bounceAnimator.presenting = false
            return bounceAnimator
        } else {
            return dismissControllerIpadAnimator
        }
    }
}