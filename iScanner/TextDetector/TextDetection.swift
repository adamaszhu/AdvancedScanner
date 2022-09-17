/// A detected text
///
/// - version: 0.1.0
/// - date: 16/09/22
/// - author: Adamas
public struct TextDetection {

    /// Detected text format
    public let textFormat: TextFormatType

    /// Detected string
    public let string: String

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

extension TextDetection: Equatable {

    static func == (lhs: TextDetection, rhs: TextDetection) -> Bool {
        String(describing: lhs.textFormat) == String(describing: rhs.textFormat)
    }
}
