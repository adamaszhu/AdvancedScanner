/// The text scanner view that can be embeded in a view controller
///
/// - version: 0.1.0
/// - date: 11/10/21
/// - author: Adamas
public class TextScannerView<Info: InfoType, ScanMode: ScanModeType>: UIView {
    
    /// The hint message
    public var hint: String = .empty {
        didSet {
            visionScannerView?.hint = hint
        }
    }
    
    /// Callback when some info is detected
    public var didDetectInfoAction: ((Info) -> Void)? {
        didSet {
            visionScannerView?.didDetectInfoAction = didDetectInfoAction
        }
    }
    
    /// The ratio of the camera view
    public private (set) var ratio: Double = 0
    
    /// The actual scanner view inside
    private var visionScannerView: VisionScannerView<Info, ScanMode>?
    
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
        let visionScannerView = VisionScannerView<Info, ScanMode>()
        ratio = visionScannerView.ratio
        addSubview(visionScannerView)
        visionScannerView.pinEdgesToSuperview()
        self.visionScannerView = visionScannerView
    }
}

import AdvancedUIKit
import UIKit
