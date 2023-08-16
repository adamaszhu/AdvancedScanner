/// Defines the UI dimentions for scan modes
///
/// - version: 0.1.0
/// - date: 11/08/23
/// - author: Adamas
extension ScanMode: ScanModePresentable {
    
    public var scanningAreaRadius: CGFloat {
        switch self {
            case .creditCard:
                return Self.creditCardCornerRatius
            default:
                return 0
        }
    }

    public func scanningAreaRect(in rect: CGRect) -> CGRect {
        let width = rect.width * Self.defaultWidthRatio
        let height: CGFloat
        let offset: CGFloat
        switch self {
            case .creditCard:
                height = width / Self.creditCardRatio
                offset = Self.defaultAreaOffset
            case .receipt:
                height = rect.height * Self.defaultHeightRatio
                offset = 0
            case .priceTag:
                height = width / Self.priceTagRatio
                offset = Self.defaultAreaOffset
            default:
                return .zero
        }
        let x = rect.width / 2 - width / 2
        let y = rect.height / 2 - height / 2 - offset
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

/// Constants
private extension ScanMode {
    static var defaultWidthRatio: CGFloat { 0.8 }
    static var defaultHeightRatio: CGFloat { 0.9 }
    static var defaultAreaOffset: CGFloat { 100 }
    static var creditCardCornerRatius: CGFloat { 10 }
    static var creditCardRatio: CGFloat { 3.0 / 2.0 }
    static var priceTagRatio: CGFloat { 2.0 }
}

import CoreGraphics
