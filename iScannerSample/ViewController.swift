final class ViewController: UIViewController {
    
    private lazy var scanner = TextScanner<CreditCardInfo, ScanMode>(viewController: self)
    
    @IBAction func scan(_ sender: Any) {
        scanner.scan { [weak self] info in
            var message: String = "Number: \(info.number)"
            if let expiry = info.expiry {
                let expiryString = expiry.string(with: DateFormat.expiryDate)
                message += "\nExpiry: \(expiryString)"
            }
            let alertController = UIAlertController(title: "Credit Card", message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(alertAction)
            self?.present(alertController, animated: true)
        }
    }
}

import UIKit
import iScanner
import AdvancedUIKit
import AdvancedFoundation
