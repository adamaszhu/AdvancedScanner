//
//  ModalViewController.swift
//  iScanner
//
//  Created by Adamas Zhu on 15/9/21.
//

import Foundation
import UIKit

open class ModalViewController: UIViewController {
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }

    private func initialize() {
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
}

extension ModalViewController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented _: UIViewController,
                                    presenting _: UIViewController,
                                    source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        FadeInAnimator()
    }

    public func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        FadeOutAnimator()
    }
}
