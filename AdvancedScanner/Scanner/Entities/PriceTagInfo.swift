/// Defines the information of a price tag
///
/// - version: 0.1.0
/// - date: 12/08/23
/// - author: Adamas
public struct PriceTagInfo {

    /// Name
    public private (set) var description: String

    /// The price
    public private (set) var price: Double

    /// Barcode
    public private (set) var barcode: String?

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
    ///   - description: Product description
    ///   - price: The price
    ///   - barcode: The barcode
    public init(description: String,
                price: Double,
                barcode: String?) {
        textDetections = []
        self.price = price
        self.barcode = barcode
        self.description = description
    }

    /// Update the info from text detections
    private mutating func update() {
        let price = textDetections[TextFormat.price]?.formattedString ?? .empty
        self.price = Self.price(fromString: price) ?? 0
        description = textDetections[TextFormat.description]?.formattedString ?? .empty
        barcode = textDetections[TextFormat.barcode]?.formattedString
    }
}

extension PriceTagInfo: InfoType {

    public var fields: [String : String] {
        [TextFormat.description.name: description,
         TextFormat.price.name: price.currencyString() ?? .empty,
         TextFormat.barcode.name: barcode ?? .empty]
    }
    
    public init?(textDetections: [TextDetection]) {
        guard let price = textDetections[TextFormat.price]?.formattedString,
              let description = textDetections[TextFormat.description]?.formattedString else {
            return nil
        }
        self.price = Self.price(fromString: price) ?? 0
        self.description = description
        self.textDetections = textDetections
        update()
    }

    public mutating func update(with textDetections: [TextDetection]) -> Bool {
        var isUpdated = false
        ScanMode.priceTag
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
