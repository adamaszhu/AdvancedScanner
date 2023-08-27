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

extension InfoType {

    /// Update the current detections with new detections
    /// - Parameters:
    ///   - currentTextDetections: The current detections
    ///   - newTextDetections: The new detections
    /// - Returns: Whether the detections has been updated or not
    func updating(_ currentTextDetections: inout [TextDetection],
                  with newTextDetections: [TextDetection]) -> Bool {
        var isUpdated = false
        Self.textFormats
            .forEach { textFormat in
                guard let newTextDetection = newTextDetections[textFormat] else {
                    return
                }
                guard let currentTextDetection = currentTextDetections[textFormat] else {
                    isUpdated = true
                    currentTextDetections.append(newTextDetection)
                    return
                }
                if newTextDetection.confidence >= currentTextDetection.confidence,
                   newTextDetection.string != currentTextDetection.string {
                    isUpdated = true
                    currentTextDetections.removeAll { $0.textFormat?.name == textFormat.name }
                    currentTextDetections.append(newTextDetection)
                }
            }
        return isUpdated
    }
}
