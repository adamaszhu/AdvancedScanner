/// The scanner that triggers a scanning view controller
///
/// - version: 0.1.0
/// - date: 11/10/21
/// - author: Adamas
open class Scanner {

    /// A list of actual scanners
    private var scanners: [InfoType: Any] = [:]

    /// Create the scanner
    /// - Parameter viewController: The current view controller
    public init(viewController: UIViewController) {
        scanners = [.creditCard: CreditCardScanner(viewController: viewController)]
    }

    /// Scan a credit card
    /// - Parameter completion: The callback when a credit card is detected
    public func scanCreditCard(completion: @escaping (CreditCardInfo) -> Void) {
        guard let scanner = scanners[.creditCard] as? CreditCardScanner else {
            Logger.standard.logError(Self.scannerError, withDetail: CreditCardScanner.self)
            return
        }
        scanner.scan(completion: completion)
    }
}

/// Constants
private extension Scanner {
    static let scannerError = "Cannot find an expected scanner"
}

import UIKit
import AdvancedFoundation
