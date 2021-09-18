//
//  BottomSheetViewController.swift
//  iScanner
//
//  Created by Adamas Zhu on 15/9/21.
//

import Foundation
import UIKit

open class BottomSheetViewController: ModalViewController {
    private var modalView: UIView = UIView()
    private var isInitialized: Bool = false
    private var ratio: Double? = nil

    init(viewController: UIViewController, ratio: Double? = nil) {
        self.ratio = ratio
        super.init(nibName: nil, bundle: nil)
        addChild(viewController)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(modalView)
        view.backgroundColor = Self.backgroundColor
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard !isInitialized else {
            return
        }
        setupModalView()
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isInitialized {
            isInitialized = true
            showModal()
        }
    }

    func showModal(completion: (() -> Void)? = nil) {
        modalView.frame.origin.y = view.bounds.height
        UIView.animate(withDuration: Animator.defaultDuration, animations: { [weak self] in
            guard let self = self else { return }
            self.modalView.frame.origin.y = self.view.bounds.height - self.modalView.bounds.height
        }, completion: { _ in
            completion?()
        })
    }

    func hideModal(completion: (() -> Void)? = nil) {
        modalView.frame.origin.y = view.bounds.height - modalView.bounds.height
        UIView.animate(withDuration: Animator.defaultDuration, animations: { [weak self] in
            guard let self = self else { return }
            self.modalView.frame.origin.y = self.view.bounds.height
        }, completion: { _ in
            completion?()
        })
    }

    private func setupModalView() {
        guard let childViewController = children.first else {
            return
        }
        modalView.translatesAutoresizingMaskIntoConstraints = false
        modalView.frame.origin = CGPoint(x: 0, y: view.bounds.height)
        let height: CGFloat
        if let ratio = ratio {
            height = view.bounds.width * CGFloat(ratio)
        } else {
            height = view.bounds.height * Self.modalHeightPercentage
        }
        modalView.frame.size = CGSize(width: view.bounds.width,
                                      height: height)
        modalView.addSubview(childViewController.view)
        childViewController.view.frame.size = modalView.frame.size
    }

    open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        hideModal {
            super.dismiss(animated: flag, completion: completion)
        }
    }
}

private extension BottomSheetViewController {
    static let backgroundColor = UIColor(white: 0, alpha: 0.6)
    static let modalHeightPercentage: CGFloat = 0.85
}
