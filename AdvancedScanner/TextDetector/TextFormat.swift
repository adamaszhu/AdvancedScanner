/// Predefined text formats
///
/// - version: 0.1.0
/// - date: 16/09/22
/// - author: Adamas
public enum TextFormat {

    /// Formatted credit card number with no space between
    case creditCardNumber

    /// The 3 digit verification number of a credit card
    /// - important: If some credit card types have different cvn length, customized TextFormat can be created which should follow TextFormatType
    case creditCardVerificationNumber

    /// An expiry date with format either as 01/30 or 01/2030
    case expiry

    /// A human full name
    case fullName
}

extension TextFormat: TextFormatType {

    public var name: String {
        switch self {
            case .creditCardNumber:
                return Self.creditCardNumberName
            case .creditCardVerificationNumber:
                return Self.creditCardVerificationNumberName
            case .expiry:
                return Self.expiryName
            case .fullName:
                return Self.fullNameName
        }
    }

    public var rules: [RuleType] {
        let errorMessage = String(format: Self.errorMessagePattern, name.lowercased())
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
            case .fullName:
                return DefaultRuleFactory.fullNameRules(withMessage: errorMessage)
        }
    }

    public var isSpaceAllowed: Bool {
        switch self {
            case .fullName:
                return true
            default:
                return false
        }
    }
}

/// Constants
private extension TextFormat {
    static let errorMessagePattern = "Cannot detect a valid %@"
    static let creditCardNumberName = "Card number"
    static let creditCardVerificationNumberName = "CVN"
    static let fullNameName = "Name"
    static let expiryName = "Expiry date"
}

import AdvancedUIKit
