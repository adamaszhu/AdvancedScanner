/// The scanner view that can be embeded in a view controller
///
/// - version: 0.1.0
/// - date: 11/10/21
/// - author: Adamas
open class ScannerView: UIView {

    /// The ratio of the camera view
    public var cameraRatio: Double {
        500.0/375.0
    }

    /// Set the type of the scanner view
    public var infoType: InfoType = .none {
        didSet {
            switch infoType {
            case .creditCard:
                setupCreditCardScannerView()
            case .none:
                break
            }
        }
    }

    /// The delegate for detecting an info type
    public weak var delegate: ScannerViewDelegate?

    /// Setup a CreditCardScannerView as the content
    private func setupCreditCardScannerView() {
        let creditCardScannerView = CreditCardScannerView()
        addSubview(creditCardScannerView)
        creditCardScannerView.pinEdgesToSuperview()
        creditCardScannerView.didDetectInfoAction = { [weak self] creditCardInfo in
            guard let self = self else { return }
            self.delegate?.scannerView(self, didDetect: creditCardInfo)
        }
    }
}

import AdvancedUIKit
