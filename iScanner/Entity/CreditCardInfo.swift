/// Defines the information of a credit card
///
/// - version: 0.1.0
/// - date: 11/10/21
/// - author: Adamas
public struct CreditCardInfo {

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

    /// Initialize the object using a card IO object
    /// - Parameter cardIOCreditCardInfo: The card IO object
    init(cardIOCreditCardInfo: CardIOCreditCardInfo) {
        number = cardIOCreditCardInfo.cardNumber
        name = cardIOCreditCardInfo.cardholderName
        cvn = cardIOCreditCardInfo.cvv
        if cardIOCreditCardInfo.expiryYear != 0,
           cardIOCreditCardInfo.expiryMonth != 0 {
            let components = DateComponents(year: Int(cardIOCreditCardInfo.expiryYear),
                                            month: Int(cardIOCreditCardInfo.expiryMonth))
            expiry = Calendar.current.date(from: components)
        } else {
            expiry = nil
        }
    }
}

import Foundation
import AdvancedFoundation
