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
        
        let backgroundView = UIView()

        let backgroundFrame = containerView.convert(
            fromVC.view.frame,
            from: fromVC.view.superview
        )

        backgroundView.frame = backgroundFrame
        backgroundView.backgroundColor = fromVC.view.backgroundColor
        //backgroundView.layer.cornerRadius = fromPizzaVC.backgroundView.layer.cornerRadius

        containerView.addSubview(fromVC.view)
        containerView.addSubview(toVC.view)
        containerView.addSubview(backgroundView)

        fromVC.view.isHidden = false
        fromVC.tableView.isHidden = true
        toVC.view.isHidden = true
        
        let frameAnim = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        let animator1 = {
            UIViewPropertyAnimator(duration: firstPartDuration, dampingRatio: 1) {
                backgroundView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
        }()

        let animator2 = {
            UIViewPropertyAnimator(duration: secondPartDuration, curve: .easeInOut) {
                backgroundView.frame = frameAnim
            }
        }()
        
        animator1.addCompletion { _ in
            animator2.startAnimation()
        }

        animator2.addCompletion { _ in
            fromVC.tableView.isHidden = false
            toVC.view.isHidden = false

            backgroundView.removeFromSuperview()

            transitionContext.completeTransition(true)
        }

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
