/// The delegate that will be called when an info object is detected.
///
/// - version: 0.1.0
/// - date: 10/11/21
/// - author: Adamas
public protocol ScannerViewDelegate: AnyObject {

    /// A credit card is detected
    /// - Parameters:
    ///   - scannerView: The scanner view that detects the credit card
    ///   - creditCardInfo: The detected credit card info
    func scannerView(_ scannerView: ScannerView,
                     didDetect creditCardInfo: CreditCardInfo)
}

import Foundation
