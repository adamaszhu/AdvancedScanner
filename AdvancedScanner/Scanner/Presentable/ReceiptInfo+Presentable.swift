/// Defines the UI dimentions for scanning a receipt
///
/// - version: 0.1.0
/// - date: 11/08/23
/// - author: Adamas
extension ReceiptInfo: InfoPresentable {

    public static var scanningAreaRadius: CGFloat { Self.radius }

    public static func scanningAreaRect(in rect: CGRect) -> CGRect {
        let width = rect.width * Self.defaultWidthRatio
        let height = rect.height * Self.heightRatio
        let offset = Self.offset
        return Self.rect(withWidth: width,
                         height: height,
                         andOffset: offset,
                         in: rect)
    }
}

/// Constants
private extension ReceiptInfo {
    static var heightRatio: CGFloat { 0.9 }
    static var offset: CGFloat { 0 }
    static var radius: CGFloat { 0 }
}

import CoreGraphics
