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
                price: String,
                barcode: String?) {
        self.price = Self.price(fromString: price) ?? 0
        self.barcode = barcode
        self.description = description
    }
}

extension PriceTagInfo: InfoType {

    public var fields: [String : String] {
        [TextFormat.description.name: description,
         TextFormat.price.name: price.currencyString() ?? .empty,
         TextFormat.barcode.name: barcode ?? .empty]
    }
    
    public init?(textDetections: [TextDetection]) {
        guard let price = textDetections[TextFormat.price],
            let description = textDetections[TextFormat.description] else {
            return nil
        }
        self.init(description: description,
                  price: price,
                  barcode: textDetections[TextFormat.barcode])
    }

    public mutating func update(with textDetections: [TextDetection]) -> Bool {
        var isUpdated: [Bool] = []
        if let description = textDetections[TextFormat.description] {
            isUpdated.append(self.description != description)
            self.description = description
        }
        if let priceString = textDetections[TextFormat.price],
           let price = Self.price(fromString: priceString) {
            isUpdated.append(self.price != price)
            self.price = price
        }
        if let barcode = textDetections[TextFormat.barcode] {
            isUpdated.append(self.barcode != barcode)
            self.barcode = barcode
        }
        return isUpdated.contains(true)
    }
}

import Foundation
import AdvancedFoundation
