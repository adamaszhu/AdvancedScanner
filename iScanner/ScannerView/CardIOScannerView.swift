/// The scanner view that can detect a credit card.
///
/// - important: CardIO was deprecated. So this view should only be used on iOS12
/// - version: 0.1.0
/// - date: 16/09/22
/// - author: Adamas
final class CardIOScannerView: UIView, TextScannerViewType {

    let ratio = 375.0 / 500.0

    var didDetectInfoAction: ((CreditCardInfo) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    /// Initialize the actual scanner view using CardIO
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

extension CardIOScannerView: CardIOViewDelegate {

    func cardIOView(_ cardIOView: CardIOView!, didScanCard cardInfo: CardIOCreditCardInfo!) {
        guard let cardInfo = cardInfo else {
            return
        }
        let creditCardInfo = CreditCardInfo(cardIOCreditCardInfo: cardInfo)
        didDetectInfoAction?(creditCardInfo)
    }
}

import AdvancedUIKit
import AdvancedFoundation
