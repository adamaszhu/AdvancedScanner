/// The scanner view that can detect a credit card
///
/// - version: 0.1.0
/// - date: 10/11/21
/// - author: Adamas
final class CreditCardScannerView: UIView, ScannerViewType {

    var didDetectInfoAction: ((CreditCardInfo) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    /// Initialize the actual Car
    private func initialize() {
        let cardIOView = CardIOView()
        addSubview(cardIOView)
        cardIOView.pinEdgesToSuperview()
        cardIOView.delegate = self
        cardIOView.hideCardIOLogo = true
        cardIOView.scannedImageDuration = 0
        cardIOView.guideColor = .white
    }
}

extension CreditCardScannerView: CardIOViewDelegate {

    func cardIOView(_ cardIOView: CardIOView!, didScanCard cardInfo: CardIOCreditCardInfo!) {
        let creditCardInfo = CreditCardInfo(cardIOCreditCardInfo: cardInfo)
        didDetectInfoAction?(creditCardInfo)
    }
}

import AdvancedUIKit
