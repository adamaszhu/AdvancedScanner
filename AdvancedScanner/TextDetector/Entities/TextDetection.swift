/// A detected text
///
/// - version: 0.1.0
/// - date: 16/09/22
/// - author: Adamas
public struct TextDetection {

    /// The original string
    public let string: String

    /// The confidence of the detection.
    public let confidence: Double

    /// Detected text format. Nil if there is no detection
    public let textFormat: TextFormatType?
}
