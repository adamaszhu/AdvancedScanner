/// The scanner that triggers a credit card scanning view controller
///
/// - version: 0.1.0
/// - date: 11/10/21
/// - author: Adamas
final class CreditCardScanner: ScannerType {

    var didDetectInfoAction: ((CreditCardInfo) -> Void)?

    /// The current view controller
    private unowned let viewController: UIViewController

    /// Create the scanner
    /// - Parameter viewController: The current view controller
    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func scan() {
        let viewController = ScannerViewController()
        viewController.infoType = .creditCard
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        let bottomSheetViewController = BottomSheetViewController(
            viewController: navigationController,
            ratio: viewController.cameraRatio)
        self.viewController.present(bottomSheetViewController, animated: true)
    }
}

extension CreditCardScanner: ScannerViewDelegate {

    func scannerView(_ scannerView: ScannerView, didDetect creditCardInfo: CreditCardInfo) {
        viewController.presentedViewController?.dismiss(animated: true) { [weak self] in
            self?.didDetectInfoAction?(creditCardInfo)
        }
    }
}

import Foundation
import AdvancedUIKit
