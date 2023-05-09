/// Utilities for detecting strings from an image
///
/// - version: 0.1.0
/// - date: 16/09/22
/// - author: Adamas
@available(iOS 13.0, *)
extension CIImage {

    /// Detect strings from the image
    /// - Parameter shouldCorrectLanguage: Whether strings should be auto corrected.
    /// - Returns: A list of detected strings
    func strings(withLanguageCorrection shouldCorrectLanguage: Bool) -> [String] {
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = shouldCorrectLanguage
        let requestHandler = VNImageRequestHandler(ciImage: self)
        try? requestHandler.perform([request])
        return request
            .results?
            .flatMap { $0.topCandidates(Self.maxCandidate)
            .filter { $0.confidence == 1 }
            .map { $0.string } } ?? []
    }
}

/// Constants
private extension CIImage {
    static let maxCandidate = 20
}

import Foundation
import Vision
import UIKit
