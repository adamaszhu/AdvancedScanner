/// The scanner view that can be embeded in a view controller
///
/// - version: 0.1.0
/// - date: 11/10/21
/// - author: Adamas
open class ScannerView<Info>: UIView, ScannerViewType {

    public var didDetectInfoAction: ((Info) -> Void)? {
        didSet {
            if #available(iOS 13.0, *) {
                (innerView as? VisionScannerView<Info>)?.didDetectInfoAction = didDetectInfoAction
            } else if Info.self == CreditCardInfo.self {
                (innerView as? CardIOScannerView)?.didDetectInfoAction = { [weak self] info in
                    self?.didDetectInfoAction?(info as! Info)
                }
            }
        }
    }

    public private (set) var ratio: Double = 0

    private var innerView: UIView?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    private func initialize() {
        let innerView: UIView
        if #available(iOS 13.0, *) {
            let visionScannerView = VisionScannerView<Info>()
            ratio = visionScannerView.ratio
            innerView = visionScannerView
        } else if Info.self == CreditCardInfo.self {
            let cardIOScannerView = CardIOScannerView()
            ratio = cardIOScannerView.ratio
            innerView = cardIOScannerView
        } else {
            return
        }
        addSubview(innerView)
        innerView.pinEdgesToSuperview()
        self.innerView = innerView
    }
}

import AdvancedUIKit
