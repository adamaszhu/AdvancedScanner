/// The interface that a customized ScanMode object should follow
///
/// - version: 0.1.0
/// - date: 16/09/22
/// - author: Adamas
public protocol ScanModeType {

    /// A list of text formats which should be detected under the mode
    var textFormats: [TextFormatType] { get }

    /// The radius of the scanning area
    var scanningAreaRadius: CGFloat { get }

    /// Decide the mode
    /// 
    /// - Parameter infoType: The information type
    init(infoType: InfoType.Type)

    /// Get the scaning area in a view
    /// - Parameter rect: The rect of the whole view
    /// - Returns: The scaning area rect
    func scanningAreaRect(in rect: CGRect) -> CGRect

    /// Generate an info from a list of text detections
    /// 
    /// - Parameter textDetections: The text detection
    /// - Returns: An info object
    func info<Info: InfoType>(from textDetections: [TextDetection]) -> Info?
}

import CoreGraphics
