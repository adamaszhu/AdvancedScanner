/// The interface that a TextFormat object should follow
///
/// - version: 0.1.0
/// - date: 16/09/22
/// - author: Adamas
public protocol TextFormatType {

    /// A list of rules that a TextFormat should follow
    var rules: [RuleType] { get }

    /// Whether or not the format can contain spaces
    var isSpaceAllowed: Bool { get }
}

public extension TextFormatType {

    /// Check if a give text format is the same as the current one.
    ///
    /// - Important: Protocol cannot be applied on protocols, otherwise the protocol cannot be used to hold an object.
    /// - Parameter textFormat: The other text format
    /// - Returns: Whether they are the same text format or not
    func isEqualTo(_ textFormat: TextFormatType) -> Bool {
        String(describing: self) == String(describing: textFormat)
    }
}

import AdvancedUIKit
