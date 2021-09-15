//
//  FadeOutAnimator.swift
//  iScanner
//
//  Created by Adamas Zhu on 15/9/21.
//

import UIKit

final class FadeOutAnimator: Animator, UIViewControllerAnimatedTransitioning {
    @objc func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            return
        }

        UIView.animate(withDuration: Animator.defaultDuration, animations: {
            fromViewController.view.alpha = 0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
