/// A detected text
///
/// - version: 0.1.0
/// - date: 16/09/22
/// - author: Adamas
public class TextDetection {

    /// Detected text format
    public let textFormat: TextFormatType

    /// Detected string
    public var string: String

    /// Create the detection
    /// - Parameters:
    ///   - textFormat: The format
    ///   - string: The string
    public init(textFormat: TextFormatType,
                string: String) {
        self.textFormat = textFormat
        self.string = string
    }
}
