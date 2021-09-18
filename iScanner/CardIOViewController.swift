//
//  CardIOViewController.swift
//  iScanner
//
//  Created by Adamas Zhu on 15/9/21.
//

import Foundation
import UIKit

final class CardIOViewController: UIViewController {

    @IBOutlet private var cardIOView: CardIOView!

    weak var delegate: CardIOViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        cardIOView.hideCardIOLogo = true
        cardIOView.scannedImageDuration = 0
        cardIOView.delegate = delegate
        cardIOView.guideColor = .white

//        navigationController?.navigationBar.style = .transparent
        navigationController?.navigationBar.tintColor = .white

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(back))

    }

    @objc private func back() {
        if let parentViewController = navigationController?.parent as? BottomSheetViewController {
            parentViewController.dismiss(animated: true)
        } else {
            navigationController?.dismiss(animated: true)
        }
    }
}

extension CardIOViewController {
    static let cameraRatio = 500.0/375.0
}
