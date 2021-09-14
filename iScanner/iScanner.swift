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

    private let cardIOScanner: CardIOScanner

    public var completion: (CreditCardInfo) -> Void {
        get {
            cardIOScanner.completion
        }
        set {
            cardIOScanner.completion = newValue
        }
    }

    public init(viewController: UIViewController) {
        cardIOScanner = CardIOScanner(viewController: viewController)
    }

    public func scanCard() {
        cardIOScanner.scanCard()
    }
}
