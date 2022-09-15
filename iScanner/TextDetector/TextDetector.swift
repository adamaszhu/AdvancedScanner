//
//  TextDetector.swift
//  iScanner
//
//  Created by Adamas Zhu on 14/9/2022.
//

import Foundation

public typealias TextDetection = (type: TextType, string: String)

public class TextDetector {

    private let textTypes: [TextType]

    public init(textTypes: [TextType]) {
        self.textTypes = textTypes
    }

    public func detect(_ strings: [String]) -> [TextDetection] {
        strings.compactMap { detect($0) }
    }

    public func detect(_ string: String) -> TextDetection? {
        for type in textTypes {
            let isValid = type.rules
                .reduce(true) { $0 && $1.isValid(value: string) == nil }
            if isValid {
                return (type, string)
            }
        }
        return nil
    }
}
