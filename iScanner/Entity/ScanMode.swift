/// The scanning mode
///
/// - version: 0.1.0
/// - date: 11/10/21
/// - author: Adamas
public enum ScanMode: ScanModeType {

    /// Credit card
    case creditCard

    /// Detect nothing
    case none

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

    public var scanningAreaRadius: CGFloat {
        switch self {
            case .creditCard:
                return Self.creditCardCornerRatius
            default:
                return 0
        }
    }

    public func scanningAreaRect(in rect: CGRect) -> CGRect {
        let width = rect.width * Self.defaultWidthRatio
        let height = width / Self.creditCardRatio
        let x = rect.width / 2 - width / 2
        let y = rect.height / 2 / height / 2 - Self.defaultAreaOffset
        return CGRect(x: x, y: y, width: width, height: height)
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

/// Constants
private extension ScanMode {
    static let defaultWidthRatio: CGFloat = 0.8
    static let defaultAreaOffset: CGFloat = 100
    static let creditCardCornerRatius: CGFloat = 10
    static let creditCardRatio: CGFloat = 3.0 / 2.0
}
