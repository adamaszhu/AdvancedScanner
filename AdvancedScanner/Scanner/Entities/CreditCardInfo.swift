/// Defines the information of a credit card
///
/// - version: 0.1.0
/// - date: 11/10/21
/// - author: Adamas
public struct CreditCardInfo {

    /// The card number
    public private (set) var number: String

    /// The expiry date
    public private (set) var expiry: Date?

    /// The name on the credit card
    public private (set) var name: String?

    /// The credit card verification number
    public private (set) var cvn: String?

    /// A list of detected texts
    private var textDetections: [TextDetection]

    /// Initialize the object
    /// - Parameters:
    ///   - number: The card number
    ///   - name: The name on the card
    ///   - cvn: The verification number
    ///   - expiry: The expiry string
    public init(number: String,
                name: String?,
                expiry: Date?,
                cvn: String?) {
        textDetections = []
        self.number = number
        self.cvn = cvn
        self.name = name
        self.expiry = expiry
    }

    /// Update the info from text detections
    private mutating func update() {
        number = textDetections[TextFormat.creditCardNumber]?.value() ?? .empty
        name = textDetections[TextFormat.fullName]?.value()
        cvn = textDetections[TextFormat.creditCardVerificationNumber]?.value()
        expiry = textDetections[TextFormat.expiry]?.value()
    }
}

extension CreditCardInfo: InfoType {

    public var fields: [String : String] {
        [TextFormat.creditCardNumber.name: number,
         TextFormat.fullName.name: name ?? .empty,
         TextFormat.expiry.name: expiry?.string(with: DateFormat.fullDate) ?? .empty,
         TextFormat.creditCardVerificationNumber.name: cvn ?? .empty]
    }
    
    public init?(textDetections: [TextDetection]) {
        guard let number: String = textDetections[TextFormat.creditCardNumber]?.value() else {
            return nil
        }
        self.number = number
        self.textDetections = textDetections
        update()
    }

    public mutating func update(with textDetections: [TextDetection]) -> Bool {
        var isUpdated = false
        ScanMode.creditCard
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
