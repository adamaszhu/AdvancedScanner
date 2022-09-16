final class ViewController: UIViewController {
    
    private lazy var scanner = Scanner(viewController: self)
    
    @IBAction func scan(_ sender: Any) {
        scanner.scanCreditCard { [weak self] creditCardInfo in
            var message: String = "Number: \(creditCardInfo.number)"
            if let expiry = creditCardInfo.expiry {
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
