//
//  AnimationController.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 14/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import UIKit

enum TransitionType {
    case presenting
    case dismissing
}

class AnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    var duration: TimeInterval
    var transitionType: TransitionType
    var sender: Any?
    
    init(with duration: TimeInterval, for transitionType: TransitionType, sender: Any?) {
        
        self.duration = duration
        self.transitionType = transitionType
        self.sender = sender
        
        super.init()
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        switch transitionType {
        case .presenting:
            self.presentingTransition(using: transitionContext)
        case .dismissing:
            self.dismissingTransition(using: transitionContext)
        }
    }
    
    private func presentingTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        containerView.backgroundColor = .white
        
        let sourceView = transitionContext.view(forKey: .from)
        let destinationController = transitionContext.viewController(forKey: .to) as? UINavigationController
        let detailsViewController = destinationController?.topViewController as? HeroDetailsViewController
        
        destinationController?.view.alpha = 0.0
        containerView.addSubview(destinationController!.view)
        
        let heroCell = self.sender as? HeroCell
        let cellThumbnailView = heroCell!.heroThumbnailView
        let detailsThumbnailView = detailsViewController?.thumbnailView

        let animatedThumbnail = UIImageView(image: cellThumbnailView!.image)
        animatedThumbnail.frame.origin = containerView.convert(cellThumbnailView!.frame.origin, from: cellThumbnailView!.superview)
        containerView.addSubview(animatedThumbnail)
        
        let fadeInAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut) {
            destinationController?.view.alpha = 1.0
        }
        
        fadeInAnimator.addCompletion { (finalPosition) in
            animatedThumbnail.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        let scaleX = detailsThumbnailView!.frame.width/animatedThumbnail.frame.width
        let scaleY = detailsThumbnailView!.frame.height/animatedThumbnail.frame.height
        let thumbnailAnimator = UIViewPropertyAnimator(duration: self.duration, curve: .easeOut) {
            
            animatedThumbnail.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            animatedThumbnail.center = containerView.convert(detailsThumbnailView!.center, from: detailsThumbnailView!.superview)
            sourceView?.alpha = 0.0
        }
        
        thumbnailAnimator.addCompletion { (finalPosition) in
            fadeInAnimator.startAnimation()
        }
        
        thumbnailAnimator.startAnimation()
    }
    
    private func dismissingTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        let sourceView = transitionContext.view(forKey: .from)
        let destinationView = transitionContext.view(forKey: .to)
        
        destinationView?.alpha = 1.0
        containerView.insertSubview(destinationView!, belowSubview: sourceView!)
        
        let fadeOutAnimator = UIViewPropertyAnimator(duration: self.duration, curve: .easeIn) { 
            sourceView?.alpha = 0.0
        }
        
        fadeOutAnimator.addCompletion { (finalPosition) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        fadeOutAnimator.startAnimation()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
}
