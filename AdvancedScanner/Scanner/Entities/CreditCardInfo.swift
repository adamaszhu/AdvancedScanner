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

    /// Convert an expiry string into a date object
    /// - Parameter expiryString: The expiry string
    /// - Returns: The date
    private static func expiry(fromString expiryString: String) -> Date? {
        [DateFormat.expiryDate, DateFormat.fullExpiryDate]
            .compactMap { Date(string: expiryString, dateFormat: $0) }
            .first
    }

    /// Initialize the object
    /// - Parameters:
    ///   - number: The card number
    ///   - name: The name on the card
    ///   - cvn: The verification number
    ///   - expiry: The expiry string
    public init(number: String,
                name: String?,
                expiry: String?,
                cvn: String?) {
        self.number = number
        self.cvn = cvn
        self.name = name
        if let expiry = expiry {
            self.expiry = Self.expiry(fromString: expiry)
        } else {
            self.expiry = nil
        }
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
        guard let number = textDetections[TextFormat.creditCardNumber] else {
            return nil
        }
        self.init(number: number,
                  name: textDetections[TextFormat.fullName],
                  expiry: textDetections[TextFormat.expiry],
                  cvn: textDetections[TextFormat.creditCardVerificationNumber])
    }

    public mutating func update(with textDetections: [TextDetection]) -> Bool {
        var isUpdated = false
        if let number = textDetections[TextFormat.creditCardNumber] {
            isUpdated = self.number != number
            self.number = number
        }
        if let name = textDetections[TextFormat.fullName] {
            isUpdated = self.name != name
            self.name = name
        }
        if let expiryString = textDetections[TextFormat.expiry],
           let expiry = Self.expiry(fromString: expiryString) {
            isUpdated = self.expiry != expiry
            self.expiry = expiry
        }
        if let cvn = textDetections[TextFormat.creditCardVerificationNumber] {
            isUpdated = self.cvn != cvn
            self.cvn = cvn
        }
        return isUpdated
    }
}

import Foundation
import AdvancedFoundation
