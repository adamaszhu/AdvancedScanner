/// Defines the information of a credit card
///
/// - version: 0.1.0
/// - date: 11/10/21
/// - author: Adamas
public struct CreditCardInfo: InfoType {

    /// The card number
    public let number: String

    /// The expiry date
    public let expiry: Date?

    /// The name on the credit card
    public let name: String?

    /// The credit card verification number
    public let cvn: String?

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
            self.expiry = [DateFormat.expiryDate, DateFormat.fullExpiryDate]
                .compactMap { Date(string: expiry, dateFormat: $0) }
                .first
        } else {
            self.expiry = nil
        }
    }
    
    /// Create the object from a list of detections
    /// - Parameter textDetections: A list of detections
    public init?(textDetections: [TextDetection]) {
        guard let number = textDetections[TextFormat.creditCardNumber].first else {
            return nil
        }
        self.init(number: number,
                  name: textDetections[TextFormat.fullName].first,
                  expiry: textDetections[TextFormat.expiry].first,
                  cvn: textDetections[TextFormat.creditCardVerificationNumber].first)

    }
}

import Foundation
import AdvancedFoundation
