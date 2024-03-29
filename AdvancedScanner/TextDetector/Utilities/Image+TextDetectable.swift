/// Utilities for detecting strings from an image
///
/// - version: 0.1.0
/// - date: 16/09/22
/// - author: Adamas
public extension CIImage {

    /// Detect strings from the image
    /// - Parameter shouldCorrectLanguage: Whether strings should be auto corrected.
    /// - Returns: A list of detected strings
    func strings(withLanguageCorrection shouldCorrectLanguage: Bool) -> [TextDetection] {
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = shouldCorrectLanguage
        let requestHandler = VNImageRequestHandler(ciImage: self)
        try? requestHandler.perform([request])
        return request
            .results?
            .compactMap { 
                $0.topCandidates(1)
                    .first { $0.confidence > Self.minConfidence }
            }
            .map { TextDetection(string: $0.string,
                                 confidence: Double($0.confidence),
                                 textFormat: nil)
            } ?? []
    }
}

/// Constants
private extension CIImage {
    static let minConfidence: Float = 0.3
}

import Vision
import UIKit
