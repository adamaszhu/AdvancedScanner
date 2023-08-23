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

    /// Get the price from a price string
    /// - Parameter priceString: The price string
    /// - Returns: The price
    private static func price(fromString priceString: String) -> Double? {
        if let price = Double(priceString) {
            return price
        }
        return Language.allCases
            .map(NumberFormatterFactory.currencyFormatter)
            .compactMap { Double(currency: priceString, numberFormatter: $0) }
            .first
    }

    /// Initialize the object
    /// - Parameters:
    ///   - price: The price
    public init(price: Double) {
        textDetections = []
        self.price = price
    }

    /// Update the info from text detections
    private mutating func update() {
        let price = textDetections[TextFormat.price]?.formattedString ?? .empty
        self.price = Self.price(fromString: price) ?? 0
    }
}

extension ReceiptInfo: InfoType {

    public var fields: [String : String] {
        [TextFormat.price.name: price.currencyString() ?? .empty]
    }

    public init?(textDetections: [TextDetection]) {
        guard let price = textDetections[TextFormat.price]?.formattedString else {
            return nil
        }
        self.price = Self.price(fromString: price) ?? 0
        self.textDetections = textDetections
        update()
    }

    public mutating func update(with textDetections: [TextDetection]) -> Bool {
        var isUpdated = false
        ScanMode.receipt
            .textFormats
            .forEach { textFormat in
                guard let newTextDetection = textDetections[textFormat] else {
                    return
                }
                if let currentTextDetection = self.textDetections[textFormat],
                   newTextDetection.confidence > currentTextDetection.confidence,
                   newTextDetection.string != currentTextDetection.string {
                    isUpdated = true
                    self.textDetections.removeAll { $0.textFormat?.name == textFormat.name }
                    self.textDetections.append(newTextDetection)
                } else {
                    isUpdated = true
                    self.textDetections.append(newTextDetection)
                }
            }
        return isUpdated
    }
}

import Foundation
import AdvancedFoundation
