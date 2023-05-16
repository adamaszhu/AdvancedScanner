//
//  ScanModePresentable.swift
//  AdvancedScanner
//
//  Created by Adamas Zhu on 13/5/2023.
//

import Foundation

public protocol ScanModePresentable {
    
    /// The radius of the scanning area
    var scanningAreaRadius: CGFloat { get }
    
    /// Get the scaning area in a view
    /// - Parameter rect: The rect of the whole view
    /// - Returns: The scaning area rect
    func scanningAreaRect(in rect: CGRect) -> CGRect
}

import CoreGraphics
