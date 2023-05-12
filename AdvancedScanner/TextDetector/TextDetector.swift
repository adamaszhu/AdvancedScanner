/// The helper class used to detect texts from images
///
/// - version: 0.1.0
/// - date: 16/09/22
/// - author: Adamas
public class TextDetector {

    /// A list of text formats to detect
    private let textTypes: [TextFormatType]

    /// Create the detector
    /// - Parameter textTypes: A list of text formats to detect
    public init(textTypes: [TextFormatType]) {
        self.textTypes = textTypes
    }

    /// Detect text formats from an image
    ///
    /// - Parameters:
    ///   - ciImage: The source image
    ///   - shouldCorrectLanguage: Whether language auto correction should be applied
    /// - Returns: A list of detected formats
    public func detect(_ ciImage: CIImage,
                       withLanguageCorrection shouldCorrectLanguage: Bool) -> [TextDetection] {
        let strings = ciImage.strings(withLanguageCorrection: shouldCorrectLanguage)
        return detect(strings)
    }

    /// Detect text formats from an array
    ///
    /// - Parameter strings: The source strings
    /// - Returns: A list of detected formats
    public func detect(_ strings: [String]) -> [TextDetection] {
        strings.compactMap { detect($0) }
    }

    /// Try to detect a text format from a string
    ///
    /// - Parameter string: The source string
    /// - Returns: The detected format, nil if the string matches none of those formats
    public func detect(_ string: String) -> TextDetection? {
        for type in textTypes {
            let formattedString = type.isSpaceAllowed
            ? string.combineSpaces()
            : string.removingSpaces()
            let isValid = type
                .rules
                .reduce(true) { $0 && $1.isValid(value: formattedString) == nil }
            if isValid {
                return TextDetection(textFormat: type, string: string)
            }
        }
        return nil
    }
}

import AdvancedFoundation
import UIKit
