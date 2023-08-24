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
        price = textDetections[TextFormat.price]?.value() ?? 0
        description = textDetections[TextFormat.description]?.value() ?? .empty
        barcode = textDetections[TextFormat.barcode]?.value()
    }
}

extension PriceTagInfo: InfoType {

    public static var textFormats: [TextFormatType] {
        [TextFormat.price,
         TextFormat.barcode,
         TextFormat.description]
    }

    public static var shouldCorrectLanguage: Bool { true }

    public var fields: [String : String] {
        [TextFormat.description.name: description,
         TextFormat.price.name: price.currencyString() ?? .empty,
         TextFormat.barcode.name: barcode ?? .empty]
    }
    
    public init?(textDetections: [TextDetection]) {
        guard let price: Double = textDetections[TextFormat.price]?.value(),
              let description: String = textDetections[TextFormat.description]?.value() else {
            return nil
        }
        self.price = price
        self.description = description
        self.textDetections = textDetections
        update()
    }

    public mutating func update(with textDetections: [TextDetection]) -> Bool {
        var isUpdated = false
        Self.textFormats
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
