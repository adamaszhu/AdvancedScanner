//
//  FadeInAnimator.swift
//  iScanner
//
//  Created by Adamas Zhu on 15/9/21.
//

import UIKit

final class FadeInAnimator: Animator, UIViewControllerAnimatedTransitioning {
    @objc func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            return
        }

        transitionContext.containerView.addSubview(toViewController.view)
        toViewController.view.alpha = 0

        UIView.animate(withDuration: Animator.defaultDuration, delay: 0.0, options: .curveEaseOut, animations: {
            toViewController.view.alpha = 1
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
