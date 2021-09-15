//
//  ViewController.swift
//  iScannerSample
//
//  Created by Adamas Zhu on 14/9/21.
//

import UIKit
import iScanner

final class ViewController: UIViewController {

    private lazy var scanner: ScannerType = iScanner(viewController: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanner.completion = { [weak self] info in
            let message: String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/yy"
            if let expiry = info.expiry {
                message = "Number: \(info.number)\nExpiry: \(dateFormatter.string(from: expiry))"
            } else {
                message = "Number: \(info.number)"
            }
            let alertViewController = UIAlertController(title: "Credit Card",
                                                        message: message,
                                                        preferredStyle: .alert)
            self?.present(alertViewController, animated: true, completion: nil)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let cardIOView = CardIOView(frame: view.bounds)
//        view.addSubview(cardIOView)
    }
    
    @IBAction func scan(_ sender: Any) {
        scanner.scanCard()
    }
}

