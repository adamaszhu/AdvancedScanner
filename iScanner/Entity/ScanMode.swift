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

    var textFormats: [TextFormatType] {
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
}
