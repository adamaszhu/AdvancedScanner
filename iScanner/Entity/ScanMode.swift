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
}
