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

    /// Initialize the object
    /// - Parameters:
    ///   - number: The card number
    ///   - expiry: The expiry date
    public init(number: String,
                expiry: Date?) {
        self.number = number
        self.expiry = expiry
    }

    /// Initialize the object using a card IO object
    /// - Parameter cardIOCreditCardInfo: The card IO object
    init(cardIOCreditCardInfo: CardIOCreditCardInfo) {
        number = cardIOCreditCardInfo.cardNumber
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
