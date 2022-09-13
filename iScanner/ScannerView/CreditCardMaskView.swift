/// The mask view that highlight a rect for the credit card
///
/// - version: 0.1.0
/// - date: 13/09/22
/// - author: Adamas
import Foundation
import UIKit

final class CreditCardMaskView: UIView {

    private var rect: CGRect?

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

private extension CreditCardMaskView {
    static let maskColor = UIColor.black.withAlphaComponent(0.6)
    static let maskCornerRatius: CGFloat = 10
}
