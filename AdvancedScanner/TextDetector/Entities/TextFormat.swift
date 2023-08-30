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

    /// A price string
    case price

    /// A date string
    case date

    /// A barcode string
    case barcode

    /// A description string
    case description
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
            case .price:
                return Self.priceName
            case .barcode:
                return Self.barcodeName
            case .description:
                return Self.descriptionName
            case .date:
                return Self.dateName
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
                var rules = DefaultRuleFactory.fullNameRules(withMessage: errorMessage)
                rules.append(UppercaseRule(message: errorMessage))
                return rules
            case .price:
                return DefaultRuleFactory.currencyRules(for: Language.allCases, withMessage: errorMessage)
            case .barcode:
                return DefaultRuleFactory.barcodeRules(withMessage: errorMessage)
            case .description:
                return [DefaultRuleFactory.phraseRule(withMessage: errorMessage)]
            case .date:
                return [DateRule(dateFormats: [DateFormat.shortCalendarDate,
                                               PriceTagDateFormat.shortDashCalendarDate],
                                 message: errorMessage)]
        }
    }

    public func sterilize(_ value: String) -> String {
        switch self {
            case .fullName, .description:
                return value.combineSpaces()
            default:
                return value.removingSpaces()
        }
    }

    public func format<Value>(_ value: String) -> Value? {
        let sterilizedValue = sterilize(value)
        switch self {
        case .barcode,
            .creditCardNumber,
            .creditCardVerificationNumber,
            .fullName,
            .description:
            return sterilizedValue as? Value
        case .expiry:
            let date = [DateFormat.expiryDate, DateFormat.fullExpiryDate]
                .compactMap { Date(string: sterilizedValue,
                                   dateFormat: $0) }
                .first
            return date as? Value
        case .date:
            let dateFormats: [DateFormatType] = [DateFormat.shortCalendarDate,
                                                 PriceTagDateFormat.shortDashCalendarDate]
            let date = dateFormats
                .compactMap { Date(string: sterilizedValue,
                                   dateFormat: $0) }
                .first
            return date as? Value
        case .price:
            if let price = Double(sterilizedValue) {
                return price as? Value
            }
            return Language.allCases
                .map(NumberFormatterFactory.currencyFormatter)
                .compactMap { Double(currency: sterilizedValue,
                                     numberFormatter: $0) }
                .first as? Value
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
    static let priceName = "Price"
    static let barcodeName = "Barcode"
    static let dateName = "Date"
    static let descriptionName = "Description"
}

import AdvancedFoundation
import Foundation

#if canImport(AdvancedUIKit)
import AdvancedUIKit
#else
import AdvancedUI
#endif
