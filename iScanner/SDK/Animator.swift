//
//  Animator.swift
//  iScanner
//
//  Created by Adamas Zhu on 15/9/21.
//

import Foundation
import UIKit

open class Animator: NSObject {
    public static let defaultDuration: TimeInterval = 0.3

    @objc(transitionDuration:) public func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        Self.defaultDuration
    }
}
