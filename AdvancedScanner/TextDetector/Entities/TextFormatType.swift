/// The interface that a TextFormat object should follow
///
/// - version: 0.1.0
/// - date: 16/09/22
/// - author: Adamas
public protocol TextFormatType {

    /// A list of rules that a TextFormat should follow
    var rules: [RuleType] { get }

    /// The field name
    var name: String { get }

    /// Format the value before checking against rules
    /// - Parameter value: The original value
    /// - Returns: The sterilized value
    func format(_ value: String) -> String
}

import AdvancedUIKit
