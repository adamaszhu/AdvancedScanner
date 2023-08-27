/// The helper class used to detect texts from images
///
/// - version: 0.1.0
/// - date: 16/09/22
/// - author: Adamas
public class TextDetector {

    /// A list of text formats to detect
    private let textTypes: [TextFormatType]

    /// Create the detector
    /// - Parameter textTypes: A list of text formats to detect. Order will decide which will be detected first
    public init(textTypes: [TextFormatType]) {
        self.textTypes = textTypes
    }

    /// Detect text formats from an image
    ///
    /// - Parameters:
    ///   - ciImage: The source image
    ///   - shouldCorrectLanguage: Whether language auto correction should be applied
    /// - Returns: A list of detection results
    public func detect(_ ciImage: CIImage,
                       withLanguageCorrection shouldCorrectLanguage: Bool) -> [TextDetection] {
        let textDetections = ciImage.strings(withLanguageCorrection: shouldCorrectLanguage)
        return textDetections.map(detectingFormat(of:))
    }

    /// Detect text formats from an array
    ///
    /// - Parameter strings: The source strings
    /// - Returns: A list of detection results
    public func detect(_ strings: [String]) -> [TextDetection] {
        let textDetections = strings.map { TextDetection(string: $0,
                                                         confidence: 1,
                                                         textFormat: nil) }
        return textDetections.map(detectingFormat(of:))
    }

    /// Try to detect a text format from a string
    ///
    /// - Parameter string: The source string
    /// - Returns: A detection result
    public func detect(_ string: String) -> TextDetection {
        let textDetection = TextDetection(string: string,
                                          confidence: 1,
                                          textFormat: nil)
        return detectingFormat(of: textDetection)
    }

    /// Detect the format of a detected text
    /// - Parameter textDetection: A detected text
    /// - Returns: Text detection with correct text format
    private func detectingFormat(of textDetection: TextDetection) -> TextDetection {
        for type in textTypes {
            let formattedString = type.sterilize(textDetection.string)
            let isValid = type
                .rules
                .allSatisfy { $0.isValid(value: formattedString) == nil }
            if isValid {
                return TextDetection(string: textDetection.string,
                                     confidence: textDetection.confidence,
                                     textFormat: type)
            }
        }
        return textDetection
    }
}

import AdvancedFoundation
import UIKit
