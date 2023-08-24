/// Defines the information of a receipt
///
/// - version: 0.1.0
/// - date: 12/08/23
/// - author: Adamas
public struct ReceiptInfo {

    /// The price
    public private (set) var price: Double

    /// A list of detected texts
    private var textDetections: [TextDetection]

    /// Initialize the object
    /// - Parameters:
    ///   - price: The price
    public init(price: Double) {
        textDetections = []
        self.price = price
    }

    /// Update the info from text detections
    private mutating func update() {
        price = textDetections[TextFormat.price]?.value() ?? 0
    }
}

extension ReceiptInfo: InfoType {

    public static var textFormats: [TextFormatType] {
        [TextFormat.price,
         TextFormat.description]
    }

    public static var shouldCorrectLanguage: Bool { true }

    public var fields: [String : String] {
        [TextFormat.price.name: price.currencyString() ?? .empty]
    }

    public init?(textDetections: [TextDetection]) {
        guard let price: Double = textDetections[TextFormat.price]?.value() else {
            return nil
        }
        self.price = price
        self.textDetections = textDetections
        update()
    }

    public mutating func update(with textDetections: [TextDetection]) -> Bool {
        let result = updating(&self.textDetections, with: textDetections)
        update()
        return result
    }
}

import Foundation
import AdvancedFoundation
