//
//  iScanner.swift
//  iScanner
//
//  Created by Adamas Zhu on 14/9/21.
//

import Foundation

public protocol ScannerType {
    var completion: (CreditCardInfo) -> Void { get set }
    func scanCard()
}

public class iScanner: ScannerType {

    private var scanner: ScannerType

    public var completion: (CreditCardInfo) -> Void {
        get {
            scanner.completion
        }
        set {
            scanner.completion = newValue
        }
    }

    public init(viewController: UIViewController) {
        scanner = CardIOScanner(viewController: viewController)
    }

    public func scanCard() {
        scanner.scanCard()
    }
}
