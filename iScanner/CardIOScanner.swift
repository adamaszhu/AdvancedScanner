//
//  CardIOScanner.swift
//  iScanner
//
//  Created by Adamas Zhu on 14/9/21.
//

import Foundation

final class CardIOScanner: NSObject, ScannerType {

    var completion: (CreditCardInfo) -> Void = { _ in }

    private unowned let viewController: UIViewController

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func scanCard() {
        let storyboard = UIStoryboard(name: String(describing: CardIOViewController.self),
                                      bundle: Bundle(for: CardIOViewController.self))
        guard let viewController = storyboard.instantiateInitialViewController() as? CardIOViewController else {
            return
        }
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        let bottomSheetViewController = BottomSheetViewController(viewController: navigationController, ratio: CardIOViewController.cameraRatio)
        self.viewController.present(bottomSheetViewController, animated: true)
    }
}

extension CardIOScanner: CardIOViewDelegate {
    func cardIOView(_ cardIOView: CardIOView!, didScanCard cardIOCreditCardInfo: CardIOCreditCardInfo!) {
        viewController.presentedViewController?.dismiss(animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + Self.completionDelay) { [weak self] in
                let creditCardInfo = CreditCardInfo(cardIOCreditCardInfo: cardIOCreditCardInfo)
                self?.completion(creditCardInfo)
            }
        }
    }
}

private extension CardIOScanner {
    static let completionDelay: TimeInterval = 0.05
}
