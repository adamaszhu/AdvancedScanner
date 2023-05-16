/// Provides a convenient accessor for a text detection array
///
/// - version: 0.1.0
/// - date: 10/05/23
/// - author: Adamas
public extension Array where Element == TextDetection {
    
    /// Get strings of a given text format in the array
    /// - Parameter textFormat: The text format
    /// - Returns: A list of strings
    subscript(_ textFormat: TextFormatType) -> [String] {
        filter { $0.textFormat.isEqualTo(textFormat) }
            .map { $0.string }
    }
}
