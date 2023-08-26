/// Defines the information of a price tag
///
/// - version: 0.1.0
/// - date: 12/08/23
/// - author: Adamas
public struct PriceTagInfo {

    /// Name
    public private (set) var description: String?

    /// The price
    public private (set) var price: Double

    /// Barcode
    public private (set) var barcode: String?

    /// The date of the price
    public private (set) var date: Date?

    /// A list of detected texts
    private var textDetections: [TextDetection]

    /// Initialize the object
    /// - Parameters:
    ///   - description: Product description
    ///   - price: The price
    ///   - barcode: The barcode
    ///   - date: The price date
    public init(price: Double,
                description: String?,
                barcode: String?,
                date: Date?) {
        textDetections = []
        self.price = price
        self.barcode = barcode
        self.description = description
        self.date = date
    }

    /// Update the info from text detections
    private mutating func update() {
        price = textDetections[TextFormat.price]?.value() ?? 0
        description = textDetections[TextFormat.description]?.value()
        barcode = textDetections[TextFormat.barcode]?.value()
        date = textDetections[TextFormat.date]?.value()
    }
}

extension PriceTagInfo: InfoType {

    public static var textFormats: [TextFormatType] {
        [TextFormat.price,
         TextFormat.barcode,
         TextFormat.date,
         TextFormat.description]
    }

    public static var shouldCorrectLanguage: Bool { true }

    public var fields: [String : String] {
        [TextFormat.description.name: description ?? .empty,
         TextFormat.price.name: price.currencyString() ?? .empty,
         TextFormat.barcode.name: barcode ?? .empty,
         TextFormat.date.name: date?.string(with: DateFormat.shortCalendarDate) ?? .empty]
    }
    
    public init?(textDetections: [TextDetection]) {
        guard let price: Double = textDetections[TextFormat.price]?.value() else {
            return nil
        }
        let description: String? = textDetections[TextFormat.description]?.value()
        let barcode: String? = textDetections[TextFormat.barcode]?.value()
        guard description != nil || barcode != nil else {
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
