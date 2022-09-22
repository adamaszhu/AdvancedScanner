/// Define objects that hold some info
///
/// - version: 0.1.0
/// - date: 16/09/22
/// - author: Adamas
public protocol InfoType {

    /// Generate info
    /// - Parameter textDetections: A list of text detected
    init?(textDetections: [TextDetection])
}
