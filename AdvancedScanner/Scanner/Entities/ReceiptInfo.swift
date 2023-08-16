/// Defines the information of a receipt
///
/// - version: 0.1.0
/// - date: 12/08/23
/// - author: Adamas
public struct ReceiptInfo: InfoType {

    /// The price
    public let price: Double

    /// Initialize the object
    /// - Parameters:
    ///   - price: The price
    public init(price: String) {
        self.price = [Language.english, Language.mandarin]
            .map(NumberFormatterFactory.currencyFormatter)
            .compactMap { Double(currency: price, numberFormatter: $0) }
            .first ?? 0
    }

    /// Create the object from a list of detections
    /// - Parameter textDetections: A list of detections
    public init?(textDetections: [TextDetection]) {
        guard let price = textDetections[TextFormat.price].first else {
            return nil
        }
        self.init(price: price)

    }
}

import Foundation
import AdvancedFoundation
