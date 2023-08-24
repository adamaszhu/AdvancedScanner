/// Define info objects that hold some info
///
/// - version: 0.1.0
/// - date: 16/09/22
/// - author: Adamas
public protocol InfoType {

    /// A list of text formats which should be detected under the mode
    static var textFormats: [TextFormatType] { get }

    /// Whether or not auto correction should be applied to the result
    static var shouldCorrectLanguage: Bool { get }

    /// Fields contained in the info
    var fields: [String: String] { get }

    /// Create the object from a list of detections
    /// - Parameter textDetections: A list of detections
    init?(textDetections: [TextDetection])

    /// Update the info with a new list of text detections
    /// - Parameter textDetections: A list of text detections
    /// - Returns: Whether or not the info has been updated
    mutating func update(with textDetections: [TextDetection]) -> Bool
}
