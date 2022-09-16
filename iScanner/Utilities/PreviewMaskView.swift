/// The mask view that highlight a rect for the object
///
/// - version: 0.1.0
/// - date: 13/09/22
/// - author: Adamas
final class PreviewMaskView: UIView {

    /// The rect that shouldn't apply the mask
    private var rect: CGRect?

    /// Create the mask view
    ///
    /// - Parameter rect: A rect that shouldn't apply the mask effect
    convenience init(rect: CGRect) {
        self.init()
        self.rect = rect
        isOpaque = false
    }

    override func draw(_ rect: CGRect) {
        Self.maskColor.setFill()
        UIRectFill(rect)

        guard let creditCardRect = self.rect else {
            return
        }
        let path = UIBezierPath(roundedRect: creditCardRect,
                                cornerRadius: Self.maskCornerRatius)
        UIColor.clear.setFill()
        UIGraphicsGetCurrentContext()?.setBlendMode(.copy)
        path.fill()
    }
}

/// Constants
private extension PreviewMaskView {
    static let maskColor = UIColor.black.withAlphaComponent(0.6)
    static let maskCornerRatius: CGFloat = 10
}

import Foundation
import UIKit
