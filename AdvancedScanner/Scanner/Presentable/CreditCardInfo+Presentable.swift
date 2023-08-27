/// Defines the UI dimentions for scanning a credit card
///
/// - version: 0.1.0
/// - date: 11/08/23
/// - author: Adamas
extension CreditCardInfo: InfoPresentable {

    public static var scanningAreaRadius: CGFloat { Self.radius }

    public static func scanningAreaRect(in rect: CGRect) -> CGRect {
        let width = rect.width * Self.defaultWidthRatio
        let height = width / Self.ratio
        let offset = Self.offset
        return Self.rect(withWidth: width,
                         height: height,
                         andOffset: offset,
                         in: rect)
    }
}

/// Constants
private extension CreditCardInfo {
    static var ratio: CGFloat { 3.0 / 2.0 }
    static var offset: CGFloat { 100 }
    static var radius: CGFloat { 10 }
}

import CoreGraphics
