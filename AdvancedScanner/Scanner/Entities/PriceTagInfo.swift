/// Defines the information of a price tag
///
/// - version: 0.1.0
/// - date: 12/08/23
/// - author: Adamas
public struct PriceTagInfo {

    /// The price
    public private (set) var price: Double

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
    public init(price: String) {
        self.price = Self.price(fromString: price) ?? 0
    }
}

extension PriceTagInfo: InfoType {

    public var fields: [String : String] {
        [TextFormat.price.name: price.currencyString() ?? .empty]
    }
    
    public init?(textDetections: [TextDetection]) {
        guard let price = textDetections[TextFormat.price] else {
            return nil
        }
        self.init(price: price)
    }

    public mutating func update(with textDetections: [TextDetection]) -> Bool {
        var isUpdated = false
        if let priceString = textDetections[TextFormat.price],
           let price = Self.price(fromString: priceString) {
            isUpdated = self.price != price
            self.price = price
        }
        return isUpdated
    }
}

import Foundation
import AdvancedFoundation
