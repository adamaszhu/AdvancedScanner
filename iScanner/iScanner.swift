//
//  iScanner.swift
//  iScanner
//
//  Created by Adamas Zhu on 14/9/21.
//

import Foundation

public class iScanner {

    public init() {
    }

    public func test(over viewController: UIViewController) {
        let vc = CardIOPaymentViewController()
        viewController.present(vc, animated: true, completion: nil)
    }
}
