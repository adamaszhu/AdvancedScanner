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

    /// The field name
    var name: String { get }
}

import AdvancedUIKit
