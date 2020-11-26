//
//  Animator.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 26.11.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit

enum AnimationType {
    case present
    case dismiss
}

final class Animator: NSObject {

    // MARK: - Variables
    private let animationDuration: Double
    private let animationType: AnimationType

    // MARK: - Init
    init(animationDuration: Double, animationType: AnimationType) {
        self.animationDuration = animationDuration
        self.animationType = animationType
    }
    
    func dismissAnimation(transitionContext: UIViewControllerContextTransitioning,
                              fromView: UIViewController,
                              toView: UIViewController) {
        let containerView = transitionContext.containerView
        containerView.addSubview(toView.view)
        containerView.addSubview(fromView.view)
        transitionContext.completeTransition(true)
    }
    
    func presentAnimation(transitionContext: UIViewControllerContextTransitioning,
                          fromView: UIViewController,
                          toView: UIViewController) {
        let containerView = transitionContext.containerView
        let firstPartDuration = (animationDuration / 3)
        let secondPartDuration = (animationDuration / 3) * 2
        
        guard let fromVC = fromView as? ContactsViewController else { return }
        guard let toVC = toView as? ProfileViewController else { return }
        
        // Mirroring the objects that we will animate.
        let backgroundView = UIView()
        let pizzaSnapshot = UIImageView()

        // Storing the frame positions.
        let backgroundFrame = containerView.convert(
            fromPizzaVC.backgroundView.frame,
            from: fromPizzaVC.backgroundView.superview
        )

        let pizzaSnapshotFrame = containerView.convert(
            fromPizzaVC.pizzaImage.frame,
            from: fromPizzaVC.pizzaImage.superview
        )

        // Setting up new objects with original attributes from the presented view controller.
        backgroundView.frame = backgroundFrame
        backgroundView.backgroundColor = fromPizzaVC.backgroundView.backgroundColor
        backgroundView.layer.cornerRadius = fromPizzaVC.backgroundView.layer.cornerRadius

        pizzaSnapshot.frame = pizzaSnapshotFrame
        pizzaSnapshot.image = fromPizzaVC.pizzaImage.image
        pizzaSnapshot.contentMode = .scaleAspectFit
        
        // Adding the subviews to the container view.
        containerView.addSubview(fromPizzaVC.view)
        containerView.addSubview(toPizzaDetailVC.view)
        containerView.addSubview(backgroundView)
        containerView.addSubview(pizzaSnapshot)

        // Hidding/Showing objects to not/be displayed while animating the transition.
        fromPizzaVC.view.isHidden = false
        fromPizzaVC.collectionView.isHidden = true
        toPizzaDetailVC.view.isHidden = true
        
        // Background view final position.
        let frameAnim = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        // Animate the view objects using PropertyAnimator
        let animator1 = {
            UIViewPropertyAnimator(duration: firstPartDuration, dampingRatio: 1) {
                backgroundView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
        }()

        let animator2 = {
            UIViewPropertyAnimator(duration: secondPartDuration, curve: .easeInOut) {
                backgroundView.frame = frameAnim
                pizzaSnapshot.transform = CGAffineTransform(rotationAngle: .pi)
                pizzaSnapshot.frame = containerView.convert(
                    toPizzaDetailVC.pizzaImage.frame,
                    from: toPizzaDetailVC.pizzaImage.superview
                )
            }
        }()
        
        // Prepare the animations sequence
        animator1.addCompletion { _ in
            animator2.startAnimation()
        }

        animator2.addCompletion { _ in
            fromPizzaVC.collectionView.isHidden = false
            toPizzaDetailVC.view.isHidden = false

            backgroundView.removeFromSuperview()
            pizzaSnapshot.removeFromSuperview()

            transitionContext.completeTransition(true)
        }

        // Run animations
        animator1.startAnimation()

    }
}

extension Animator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(exactly: animationDuration) ?? 0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toViewController = transitionContext.viewController(forKey: .to),
            let fromViewController = transitionContext.viewController(forKey: .from)
        else {
            transitionContext.completeTransition(false)
            return
        }

        switch animationType {
        case .present:
            presentAnimation(
                transitionContext: transitionContext,
                fromView: fromViewController,
                toView: toViewController
            )
        case .dismiss:
            dismissAnimation(
                transitionContext: transitionContext,
                fromView: fromViewController,
                toView: toViewController
            )
        }
    }
}
