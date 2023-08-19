/// The result of the text detection
///
/// - version: 0.1.0
/// - date: 16/08/23
/// - author: Adamas
public struct TextDetectionResult {

    /// Strings in the image
    public let strings: [String]

    /// A list of detections
    public let detections: [Int: TextDetection]
}
