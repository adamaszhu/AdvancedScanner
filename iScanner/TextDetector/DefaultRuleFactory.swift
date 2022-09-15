//
//  DefaultRuleFactory.swift
//  iScanner
//
//  Created by Adamas Zhu on 14/9/2022.
//

import Foundation
import AdvancedUIKit

extension DefaultRuleFactory {

    public static func creditCardVerificationNumberRules(withInvalidMessage invalidMessage: String,
                                                  andLengthMessage lengthMessage: String) -> [RuleType] {
        [numberRule(withMessage: invalidMessage),
         MinLengthRule(minLength: Self.creditCardVerificationNumberLength,
                       message: lengthMessage),
         MaxLengthRule(maxLength: Self.creditCardVerificationNumberLength,
                       message: lengthMessage)]
    }

    public static func expiryRules(withMessage message: String) -> [RuleType] {
        [DateRule(dateFormats: [.expiryDate, .fullExpiryDate],
                  message: message)]
    }

    public static func creditCardNumberRules(withInvalidMessage invalidMessage: String,
                                     minLengthMessage: String,
                                     andMaxLengthMessage maxLengthMessage: String) -> [RuleType] {
        [numberRule(withMessage: invalidMessage),
         MinLengthRule(minLength: Self.creditCardNumberMinLength,
                       message: minLengthMessage),
         MaxLengthRule(maxLength: Self.creditCardNumberMaxLength,
                       message: maxLengthMessage),
         LuhnRule(message: invalidMessage)]
    }
}

private extension DefaultRuleFactory {
    static let creditCardNumberMinLength = 13
    static let creditCardNumberMaxLength = 16
    static let creditCardVerificationNumberLength = 3
}
