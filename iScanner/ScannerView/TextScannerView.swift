/// The text scanner view that can be embeded in a view controller
///
/// - version: 0.1.0
/// - date: 11/10/21
/// - author: Adamas
public class TextScannerView<Info: InfoType, ScanMode: ScanModeType>: UIView, TextScannerViewType {

    public var hint: String = .empty {
        didSet {
            if #available(iOS 13.0, *) {
                let visionScannerView = textScannerView as? VisionScannerView<Info, ScanMode>
                visionScannerView?.hint = hint
            }
        }
    }

    public var didDetectInfoAction: ((Info) -> Void)? {
        didSet {
            if #available(iOS 13.0, *) {
                let visionScannerView = textScannerView as? VisionScannerView<Info, ScanMode>
                visionScannerView?.didDetectInfoAction = didDetectInfoAction
            } else if Info.self == CreditCardInfo.self {
                let cardIOScannerView = textScannerView as? CardIOScannerView
                cardIOScannerView?.didDetectInfoAction = { [weak self] info in
                    self?.didDetectInfoAction?(info as! Info)
                }
            }
        }
    }

    public private (set) var ratio: Double = 0

    /// The actual scanner view inside
    private var textScannerView: UIView?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    /// Fill the scanner view with the actual scanner view
    private func initialize() {
        let textScannerView: UIView
        if #available(iOS 13.0, *) {
            let visionScannerView = VisionScannerView<Info, ScanMode>()
            ratio = visionScannerView.ratio
            textScannerView = visionScannerView
        } else if Info.self == CreditCardInfo.self {
            let cardIOScannerView = CardIOScannerView()
            ratio = cardIOScannerView.ratio
            textScannerView = cardIOScannerView
        } else {
            return
        }
        addSubview(textScannerView)
        textScannerView.pinEdgesToSuperview()
        self.textScannerView = textScannerView
    }
}

import AdvancedUIKit
