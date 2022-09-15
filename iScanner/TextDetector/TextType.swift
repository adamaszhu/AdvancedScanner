//
//  TextType.swift
//  iScanner
//
//  Created by Adamas Zhu on 14/9/2022.
//

import Foundation
import AdvancedUIKit

public enum TextType: String {
    case creditCardNumber = "credit card number"
    case expiry = "expiry date"
    case creditCardVerificationNumber = "card verification number"

    var rules: [RuleType] {
        let errorMessage = String(format: Self.errorMessagePattern, rawValue)
        switch self {
            case .creditCardNumber:
                return DefaultRuleFactory.creditCardNumberRules(withInvalidMessage: errorMessage,
                                                               minLengthMessage: errorMessage,
                                                               andMaxLengthMessage: errorMessage)
            case .expiry:
                return DefaultRuleFactory.expiryRules(withMessage: errorMessage)
            case .creditCardVerificationNumber:
                return DefaultRuleFactory.creditCardVerificationNumberRules(withInvalidMessage: errorMessage,
                andLengthMessage: errorMessage)
        }
    }
}

private extension TextType {
    static let errorMessagePattern = "Cannot detect a valid %@"
}
