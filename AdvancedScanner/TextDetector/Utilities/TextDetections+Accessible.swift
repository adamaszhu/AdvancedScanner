/// Provides a convenient accessor for a text detection array
///
/// - version: 0.1.0
/// - date: 10/05/23
/// - author: Adamas
public extension Array where Element == TextDetection {

    /// Get the first detection of a given text format in the array
    /// - Parameter textFormat: The text format
    /// - Returns: A matching detection
    subscript(_ textFormat: TextFormatType) -> TextDetection? {
        first { $0.textFormat?.name == textFormat.name }
    }
}
