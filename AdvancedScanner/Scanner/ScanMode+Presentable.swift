//
//  ScanMode+Presentable.swift
//  AdvancedScanner
//
//  Created by Adamas Zhu on 13/5/2023.
//

import Foundation

extension ScanMode: ScanModePresentable {
    
    public var scanningAreaRadius: CGFloat {
        switch self {
            case .creditCard:
                return Self.creditCardCornerRatius
            default:
                return 0
        }
    }

    public func scanningAreaRect(in rect: CGRect) -> CGRect {
        switch self {
            case .creditCard:
                let width = rect.width * Self.defaultWidthRatio
                let height = width / Self.creditCardRatio
                let x = rect.width / 2 - width / 2
                let y = rect.height / 2 - height / 2 - Self.defaultAreaOffset
                return CGRect(x: x, y: y, width: width, height: height)
            default:
                return .zero
        }
    }
}

/// Constants
private extension ScanMode {
    static var defaultWidthRatio: CGFloat { 0.8 }
    static var defaultAreaOffset: CGFloat { 100 }
    static var creditCardCornerRatius: CGFloat { 10 }
    static var creditCardRatio: CGFloat { 3.0 / 2.0 }
}

import UIKit
