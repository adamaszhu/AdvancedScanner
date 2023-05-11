final class ViewController: UIViewController {
    
    private lazy var scanner = TextScanner<CreditCardInfo, ScanMode>(viewController: self)
    
    @IBAction private func scan(_ sender: Any) {
        scanner.scan(withHint: "Hold the card inside the frame.\nIt will be scanned automatically.") { [weak self] info in
            self?.show(info)
        }
    }
    
    private func show(_ info: CreditCardInfo) {
        var message: String = "Number: \(info.number)"
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
}

import UIKit
import AdvancedScanner
import AdvancedUIKit
import AdvancedFoundation
