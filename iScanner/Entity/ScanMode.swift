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

    var textTypes: [TextType] {
        switch self {
            case .creditCard:
                return [.creditCardNumber, .expiry, .creditCardVerificationNumber, .fullName]
            case .none:
                return []
        }
    }
}
