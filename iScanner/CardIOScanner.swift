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
        guard let paymentViewController = CardIOPaymentViewController(paymentDelegate: self) else {
            return
        }
        paymentViewController.disableManualEntryButtons = true
        paymentViewController.suppressScanConfirmation = true
        paymentViewController.hideCardIOLogo = true
        paymentViewController.scannedImageDuration = 0
        viewController.present(paymentViewController, animated: true)
    }
}

extension CardIOScanner: CardIOPaymentViewControllerDelegate {

    func userDidCancel(_ viewController: CardIOPaymentViewController) {
        viewController.dismiss(animated: true)
    }

    func userDidProvide(_ cardIOCreditCardInfo: CardIOCreditCardInfo!, in viewController: CardIOPaymentViewController) {
        viewController.dismiss(animated: true) {
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
