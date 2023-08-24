/// Defines the UI dimentions for scanning a price tag
///
/// - version: 0.1.0
/// - date: 11/08/23
/// - author: Adamas
extension PriceTagInfo: InfoPresentable {

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
private extension PriceTagInfo {
    static var ratio: CGFloat { 2.0 }
    static var offset: CGFloat { 0 }
    static var radius: CGFloat { 0 }
}

import CoreGraphics
