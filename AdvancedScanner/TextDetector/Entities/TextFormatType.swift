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

    /// Sterilize the value before checking against rules
    /// - Parameter value: The original value
    /// - Returns: The sterilized value
    func sterilize(_ value: String) -> String

    /// Format the value into a given data type
    /// - Parameter value: The original value
    /// - Returns: A data object
    func format<Value>(_ value: String) -> Value?
}

#if canImport(AdvancedUIKit)
import AdvancedUIKit
#else
import AdvancedUI
#endif
