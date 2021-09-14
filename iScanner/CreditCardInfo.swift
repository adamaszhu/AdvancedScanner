//
//  CreditCardInfo.swift
//  iScanner
//
//  Created by Adamas Zhu on 14/9/21.
//

import Foundation

public struct CreditCardInfo {

    public let number: String
    public let expiry: Date?

    public init(number: String,
                expiry: Date?) {
        self.number = number
        self.expiry = expiry
    }

    init(cardIOCreditCardInfo :CardIOCreditCardInfo) {
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
