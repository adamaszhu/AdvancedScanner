/// Defines the UI dimentions for scanning an info
///
/// - version: 0.1.0
/// - date: 11/08/23
/// - author: Adamas
public protocol InfoPresentable {
    
    /// The radius of the scanning area
    static var scanningAreaRadius: CGFloat { get }
    
    /// Get the scaning area in a view
    /// - Parameter rect: The rect of the whole view
    /// - Returns: The scaning area rect
    static func scanningAreaRect(in rect: CGRect) -> CGRect
}

extension InfoPresentable {

    /// Get a rect inside a rect
    /// - Parameters:
    ///   - width: The width of the rect
    ///   - height: The height of the rect
    ///   - offset: The offset of the rect
    ///   - rect: The parent rect
    /// - Returns: The inside rect
    static func rect(withWidth width: CGFloat,
                     height: CGFloat,
                     andOffset offset: CGFloat,
                     in rect: CGRect) -> CGRect {
        let x = rect.width / 2 - width / 2
        let y = rect.height / 2 - height / 2 - offset
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

/// Constants
extension InfoPresentable {
    static var defaultWidthRatio: CGFloat { 0.8 }
}

import CoreGraphics
