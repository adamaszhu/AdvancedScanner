/// The scanning mode
///
/// - version: 0.1.0
/// - date: 11/10/21
/// - author: Adamas
public enum ScanMode {
    
    /// Credit card
    case creditCard

    /// Price tag
    case priceTag

    /// Receipt
    case receipt
    
    /// Detect nothing
    case none
}

extension ScanMode: ScanModeType {
    
    public var shouldCorrectLanguage: Bool {
        switch self {
        case .priceTag, .receipt:
            return true
        default:
            return false
        }
    }

    public var textFormats: [TextFormatType] {
        switch self {
            case .creditCard:
                return [TextFormat.creditCardNumber,
                        TextFormat.expiry,
                        TextFormat.creditCardVerificationNumber,
                        TextFormat.fullName]
            case .priceTag, .receipt:
                return [TextFormat.price]
            case .none:
                return []
        }
    }

    public init(infoType: InfoType.Type) {
        if infoType == CreditCardInfo.self {
            self = .creditCard
        } else if infoType == ReceiptInfo.self {
            self = .receipt
        } else if infoType == PriceTagInfo.self {
            self = .priceTag
        } else {
            self = .none
        }
    }

    public func info<Info>(from textDetections: [TextDetection]) -> Info? where Info : InfoType {
        switch self {
            case .creditCard:
                return CreditCardInfo(textDetections: textDetections) as? Info
        case .priceTag:
            return PriceTagInfo(textDetections: textDetections) as? Info
        case .receipt:
            return ReceiptInfo(textDetections: textDetections) as? Info
            default:
                return nil
        }
    }
}
import UIKit
