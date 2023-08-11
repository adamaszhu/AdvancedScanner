/// Defines the UI dimentions for a scan mode
///
/// - version: 0.1.0
/// - date: 11/08/23
/// - author: Adamas
public protocol ScanModePresentable {
    
    /// The radius of the scanning area
    var scanningAreaRadius: CGFloat { get }
    
    /// Get the scaning area in a view
    /// - Parameter rect: The rect of the whole view
    /// - Returns: The scaning area rect
    func scanningAreaRect(in rect: CGRect) -> CGRect
}

import CoreGraphics
