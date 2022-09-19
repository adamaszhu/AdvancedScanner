/// The mask view that highlight a rect for the object
///
/// - version: 0.1.0
/// - date: 13/09/22
/// - author: Adamas
final class PreviewMaskView: UIView {

    /// The rect that shouldn't apply the mask
    private var rect: CGRect?

    /// The ratius of the highlighted area
    private var rectRadius: CGFloat?

    /// Create the mask view
    ///
    /// - Parameters:
    ///  - rect: A rect that shouldn't apply the mask effect
    ///  - rectRadius: The ratius of the rect
    convenience init(rect: CGRect, rectRadius: CGFloat) {
        self.init()
        self.rect = rect
        self.rectRadius = rectRadius
        isOpaque = false
    }

    override func draw(_ rect: CGRect) {
        Self.maskColor.setFill()
        UIRectFill(rect)

        guard let rect = self.rect,
        let rectRadius = self.rectRadius else {
            return
        }
        let path = UIBezierPath(roundedRect: rect,
                                cornerRadius: rectRadius)
        UIColor.clear.setFill()
        UIGraphicsGetCurrentContext()?.setBlendMode(.copy)
        path.fill()
    }
}

/// Constants
private extension PreviewMaskView {
    static let maskColor = UIColor.black.withAlphaComponent(0.6)
}

import Foundation
import UIKit
