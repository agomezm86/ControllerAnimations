//
//  AnimatorUtils.swift
//  ControllerAnimations
//
//  Created by Field Service on 3/16/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

import UIKit
import QuartzCore

let TableCellAnimatorStartTransform:CATransform3D = {
    let rotationDegrees: CGFloat = -90.0
    let rotationRadians: CGFloat = rotationDegrees * (CGFloat(M_PI)/180.0)
    let offset = CGPointMake(-20, -20)
    
    var startTransform = CATransform3DIdentity
    startTransform = CATransform3DRotate(CATransform3DIdentity,
        rotationRadians, 0.0, 0.0, 1.0)
    startTransform = CATransform3DTranslate(startTransform, offset.x, offset.y, 0.0)
    
    return startTransform
}()

struct AnimationHelper {
    static func yRotation(angle: Double) -> CATransform3D {
        return CATransform3DMakeRotation(CGFloat(angle), 0.0, 1.0, 0.0)
    }
    
    static func perspectiveTransformForContainerView(containerView: UIView) {
        var transform = CATransform3DIdentity
        transform.m34 = -0.002
        containerView.layer.sublayerTransform = transform
    }
}

/**
 Animación para las celdas de la tabla
*/
class TableCellAnimator: NSObject {
    
    class func animateCell(cell: UITableViewCell) {
        let view = cell.contentView
        
        view.layer.transform = TableCellAnimatorStartTransform
        view.layer.opacity = 0.8
        
        UIView.animateWithDuration(0.6) {
            view.layer.transform = CATransform3DIdentity
            view.layer.opacity = 1
        }
    }
}

/**
 Presentación tipo flip para controladores
*/
class FlipPresentControllerAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var originFrame = CGRectZero
    
    /**
     Duración de la animación
     */
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.5
    }
    
    /**
     Animación
     */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        /**
        Se obtiene las dos vistas a animar
        */
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let containerView = transitionContext.containerView(),
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
                return
        }
        
        let initialFrame = originFrame
        let finalFrame = transitionContext.finalFrameForViewController(toVC)
        
        /**
         Se toma una captura de pantalla de la vista a presenta
         y se agrega a la vista actual
         */
        let snapshot = toVC.view.snapshotViewAfterScreenUpdates(true)
        snapshot.frame = initialFrame
        snapshot.layer.masksToBounds = true
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        toVC.view.hidden = true
        
        AnimationHelper.perspectiveTransformForContainerView(containerView)
        snapshot.layer.transform = AnimationHelper.yRotation(M_PI_2)
        let duration = transitionDuration(transitionContext)
        
        /**
        Se realiza el proceso de rotación de la vista principal
        */
        UIView.animateKeyframesWithDuration(
            duration,
            delay: 0,
            options: .CalculationModeCubic,
            animations: {
                
                UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 1/3, animations: {
                    fromVC.view.layer.transform = AnimationHelper.yRotation(-M_PI_2)
                })
                
                UIView.addKeyframeWithRelativeStartTime(1/3, relativeDuration: 1/3, animations: {
                    snapshot.layer.transform = AnimationHelper.yRotation(0.0)
                })
                
                UIView.addKeyframeWithRelativeStartTime(2/3, relativeDuration: 1/3, animations: {
                    snapshot.frame = finalFrame
                })
            },
            completion: { _ in
                toVC.view.hidden = false
                snapshot.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }
}


/**
 Dismiss tipo flip para controladores
*/
class FlipDismissControllerAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var destinationFrame = CGRectZero
    
    /**
     Duración de la animación
     */
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.5
    }
    
    /**
     Animación
     */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        /**
        Se obtiene las dos vistas a animar
        */
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let containerView = transitionContext.containerView(),
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
                return
        }
        
        let finalFrame = destinationFrame
        
        /**
         Se toma una captura de pantalla de la vista a presenta
         y se agrega a la vista actual
         */
        let snapshot = fromVC.view.snapshotViewAfterScreenUpdates(false)
        snapshot.layer.masksToBounds = true
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        fromVC.view.hidden = true
        
        AnimationHelper.perspectiveTransformForContainerView(containerView)
        toVC.view.layer.transform = AnimationHelper.yRotation(-M_PI_2)
        let duration = transitionDuration(transitionContext)
        
        /**
        Se realiza el proceso de rotación de la vista principal
        */
        UIView.animateKeyframesWithDuration(
            duration,
            delay: 0,
            options: .CalculationModeCubic,
            animations: {
                
                UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 1/3, animations: {
                    snapshot.frame = finalFrame
                })
                
                UIView.addKeyframeWithRelativeStartTime(1/3, relativeDuration: 1/3, animations: {
                    snapshot.layer.transform = AnimationHelper.yRotation(M_PI_2)
                })
                
                UIView.addKeyframeWithRelativeStartTime(2/3, relativeDuration: 1/3, animations: {
                    toVC.view.layer.transform = AnimationHelper.yRotation(0.0)
                })
            },
            completion: { _ in
                fromVC.view.hidden = false
                snapshot.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }
}


/**
 Presentación de vista que incluye un efecto rebote
*/
class BounceAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var presenting = true
    var originFrame = CGRect.zero
    var duration = 1.0
    
    var presentingController: UIViewController?
    var presentedControlled: UIViewController?
    
    /**
     Duración de la animación
     */
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
        
    }
    
    /**
     Animación
    */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        /**
         Se obtiene las dos vistas a animar
         */
        let containerView = transitionContext.containerView()
        
        let toView: UIView?
        if #available(iOS 8.0, *) {
            toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        } else {
            toView = presentedControlled?.view
        }
        
        let presentView: UIView?
        if #available(iOS 8.0, *) {
            presentView = presenting ? toView : transitionContext.viewForKey(UITransitionContextFromViewKey)!
        } else {
            presentView = presentingController?.view
        }
        
        /**
         Se obtiene los frames iniciales de la animación
         y el factor de transformación para que las vistas vayan
         disminuyendo progresivamente su frame
         */
        let initialFrame = presenting ? originFrame : presentView!.frame
        let finalFrame = presenting ? presentView!.frame : originFrame
        
        let xScaleFactor = presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width
        
        let yScaleFactor = presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor)
        
        if presenting {
            presentView!.transform = scaleTransform
            presentView!.center = CGPoint(
                x: CGRectGetMidX(initialFrame),
                y: CGRectGetMidY(initialFrame))
            presentView!.clipsToBounds = true
        }
        
        containerView?.addSubview(toView!)
        containerView?.bringSubviewToFront(presentView!)
        
        /**
        Se realiza el proceso de animación de la vista principal
        */
        UIView.animateWithDuration(
            duration,
            delay: 0.0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 0.0,
            options: [],
            animations: {
                presentView!.transform = self.presenting ? CGAffineTransformIdentity : scaleTransform
                presentView!.center = CGPoint(x: CGRectGetMidX(finalFrame),
                    y: CGRectGetMidY(finalFrame))
            }, completion: {
                _ in transitionContext.completeTransition(true)
        })
        
        /**
         Se agregan bordes redondos a la vista que se anima
         */
        let round = CABasicAnimation(keyPath: "cornerRadius")
        round.fromValue = presenting ? 20.0/xScaleFactor : 0.0
        round.toValue = presenting ? 0.0 : 20.0/xScaleFactor
        round.duration = duration / 2
        
        presentView!.layer.addAnimation(round, forKey: nil)
        presentView!.layer.cornerRadius = presenting ? 0.0 : 20.0/xScaleFactor
    }
}

/**
 Presentación para ipad con efecto rebote
*/
class PresentControllerIpadAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    /**
     Duración de la animación
     */
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 2.5
    }
    
    /**
     Animación
     */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        /**
         Se obtiene las dos vistas a animar
         */
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let finalFrameForVC = transitionContext.finalFrameForViewController(toViewController)
        let containerView = transitionContext.containerView()
        let bounds = UIScreen.mainScreen().bounds
        
        toViewController.view.frame = CGRectOffset(finalFrameForVC, 0, -bounds.size.height)
        containerView!.addSubview(toViewController.view)
        
        /**
        Se realiza el proceso de animación de la vista principal
        */
        UIView.animateWithDuration(
            transitionDuration(transitionContext),
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.0,
            options: .CurveLinear,
            animations: {
                toViewController.view.frame = finalFrameForVC
            }, completion: {
                finished in
                transitionContext.completeTransition(true)
                fromViewController.view.alpha = 1.0
        })
    }
}


/**
 Animación de dismiss para vista de ipad con efecto de reducción
*/
class DismissControllerIpadAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    /**
     Duración de la animación
     */
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 2
    }
    
    /**
     Animación
     */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        /**
         Se obtiene las dos vistas a animar
         */
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let finalFrameForVC = transitionContext.finalFrameForViewController(toViewController)
        let containerView = transitionContext.containerView()
        toViewController.view.frame = finalFrameForVC
        toViewController.view.alpha = 0.5
        containerView!.addSubview(toViewController.view)
        containerView!.sendSubviewToBack(toViewController.view)
        
        let snapshotView = fromViewController.view.snapshotViewAfterScreenUpdates(false)
        snapshotView.frame = fromViewController.view.frame
        containerView!.addSubview(snapshotView)
        fromViewController.view.removeFromSuperview()
        
        /**
        Se realiza el proceso de animación de la vista principal
        */
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            snapshotView.frame = CGRectInset(fromViewController.view.frame, fromViewController.view.frame.size.width / 2, fromViewController.view.frame.size.height / 2)
            toViewController.view.alpha = 1.0
            }, completion: {
                finished in
                snapshotView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }
}

/**
 Animación tipo flip para presentación de vista en ipad
*/
class FlipControllerIpadAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var reverse: Bool = false
    
    /**
     Duración de la animación
     */
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.5
    }
    
    /**
     Animación
     */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        /**
         Se obtiene las dos vistas a animar
         */
        let containerView = transitionContext.containerView()
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toView = toViewController.view
        let fromView = fromViewController.view
        let direction: CGFloat = reverse ? -1 : 1
        let const: CGFloat = -0.005
        
        toView.layer.anchorPoint = CGPointMake(direction == 1 ? 0 : 1, 0.5)
        fromView.layer.anchorPoint = CGPointMake(direction == 1 ? 1 : 0, 0.5)
        
        var viewFromTransform: CATransform3D = CATransform3DMakeRotation(direction * CGFloat(M_PI_2), 0.0, 1.0, 0.0)
        var viewToTransform: CATransform3D = CATransform3DMakeRotation(-direction * CGFloat(M_PI_2), 0.0, 1.0, 0.0)
        viewFromTransform.m34 = const
        viewToTransform.m34 = const
        
        containerView!.transform = CGAffineTransformMakeTranslation(direction * containerView!.frame.size.width / 2.0, 0)
        toView.layer.transform = viewToTransform
        containerView!.addSubview(toView)
        
        /**
        Se realiza el proceso de animación de la vista principal
        */
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            containerView!.transform = CGAffineTransformMakeTranslation(-direction * containerView!.frame.size.width / 2.0, 0)
            fromView.layer.transform = viewFromTransform
            toView.layer.transform = CATransform3DIdentity
            }, completion: {
                finished in
                containerView!.transform = CGAffineTransformIdentity
                fromView.layer.transform = CATransform3DIdentity
                toView.layer.transform = CATransform3DIdentity
                fromView.layer.anchorPoint = CGPointMake(0.5, 0.5)
                toView.layer.anchorPoint = CGPointMake(0.5, 0.5)
                
                if (transitionContext.transitionWasCancelled()) {
                    toView.removeFromSuperview()
                } else {
                    fromView.removeFromSuperview()
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }
}
