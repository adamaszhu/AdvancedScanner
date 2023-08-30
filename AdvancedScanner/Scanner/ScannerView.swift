/// A swift ui view that triggers a scanning view controller
///
/// - version: 0.1.0
/// - date: 30/08/23
/// - author: Adamas
public struct ScanView<Info: InfoType & InfoPresentable>: UIViewControllerRepresentable {

    public typealias UIViewControllerType = UINavigationController

    /// The hint message displayed on the screen
    private let hint: String

    /// Callback when the given info is detected
    private let completion: (Info) -> Void

    /// Initialize the view
    /// - Parameters:
    ///   - hint: The hint message displayed on the screen
    ///   - completion: Callback when the given info is detected
    public init(hint: String,
                completion: @escaping (Info) -> Void) {
        self.hint = hint
        self.completion = completion
    }

    public func makeUIViewController(context: Context) -> UINavigationController {
        let viewController = TextScannerViewController<Info>()
        viewController.hint = hint
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.didDetectInfoAction = { [weak navigationController] info in
            navigationController?.dismiss(animated: true) {
                completion(info)
            }
        }
        return navigationController
    }

    public func updateUIViewController(_ uiViewController: UINavigationController,
                                       context: Context) {}
}

import UIKit
import SwiftUI
