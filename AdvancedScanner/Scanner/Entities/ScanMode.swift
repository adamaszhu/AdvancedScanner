/// The scanning mode
///
/// - version: 0.1.0
/// - date: 11/10/21
/// - author: Adamas
public enum ScanMode {
    
    /// Credit card
    case creditCard
    
    /// Detect nothing
    case none
}

extension ScanMode: ScanModeType {
    
    public var shouldCorrectLanguage: Bool {
        switch self {
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
            case .none:
                return []
        }
    }

    public init(infoType: InfoType.Type) {
        if infoType == CreditCardInfo.self {
            self = .creditCard
        } else {
            self = .none
        }
    }

    public func info<Info>(from textDetections: [TextDetection]) -> Info? where Info : InfoType {
        switch self {
            case .creditCard:
                return CreditCardInfo(textDetections: textDetections) as? Info
            default:
                return nil
        }
    }
}
import UIKit
