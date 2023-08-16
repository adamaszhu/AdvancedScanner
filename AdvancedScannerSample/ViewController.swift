final class ViewController: UIViewController {
    
    private lazy var scanner = TextScanner<PriceTagInfo, ScanMode>(viewController: self)
    
    @IBAction private func scan(_ sender: Any) {
        scanner.scan(withHint: "Hold the price tag inside the frame.\nIt will be scanned automatically.") { [weak self] info in
            self?.show(info)
        }
    }
    
    private func show(_ info: CreditCardInfo) {
        var message = "Number: \(info.number)"
        if let expiry = info.expiry {
            let expiryString = expiry.string(with: DateFormat.expiryDate)
            message += "\nExpiry: \(expiryString)"
        }
        if let name = info.name {
            message += "\nName: \(name)"
        }
        if let cvn = info.cvn {
            message += "\nCVN: \(cvn)"
        }
        let messageHelper = SystemMessageHelper()
        messageHelper?.showInfo(message,
                               withTitle: "Credit Card",
                               withConfirmButtonName: "OK")
    }

    private func show(_ info: PriceTagInfo) {
        let message = "Price: \(info.price.currencyString() ?? "-")"
        let messageHelper = SystemMessageHelper()
        messageHelper?.showInfo(message,
                               withTitle: "Price Tag",
                               withConfirmButtonName: "OK")
    }
}

import UIKit
import AdvancedScanner
import AdvancedUIKit
import AdvancedFoundation
