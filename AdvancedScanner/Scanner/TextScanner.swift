/// The text scanner that triggers a scanning view controller
///
/// - version: 0.1.0
/// - date: 11/10/21
/// - author: Adamas
public class TextScanner {

    /// The current view controller
    private weak var viewController: UIViewController?

    /// Create the scanner
    /// - Parameter viewController: The current view controller
    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    /// Trigger the scanning view
    /// - Parameters:
    ///  - hint: The hint message displayed on the screen
    ///  - screen: The screen of the device
    ///  - completion: Callback when the given info is detected
    public func scan<Info: InfoType & InfoPresentable>(
        withHint hint: String,
        on screen: UIScreen = UIScreen.main,
        completion: @escaping (Info) -> Void) {
        let viewController = TextScannerViewController<Info>()
        viewController.didDetectInfoAction = { [weak self] info in
            self?.viewController?.presentedViewController?.dismiss(animated: true) {
                completion(info)
            }
        }
        viewController.hint = hint
        let navigationController = UINavigationController(rootViewController: viewController)
        let ratio = TextScannerViewController<Info>.ratio(on: screen)
        let bottomSheetViewController = BottomSheetViewController(
            viewController: navigationController,
            mode: .ratio(ratio))
        self.viewController?.present(bottomSheetViewController, animated: true)
    }
}

import AdvancedFoundation
import AdvancedUIKit
import UIKit
