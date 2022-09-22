/// The text scanner that triggers a scanning view controller
///
/// - version: 0.1.0
/// - date: 11/10/21
/// - author: Adamas
public class TextScanner<Info: InfoType, ScanMode: ScanModeType> {

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
    ///  - completion: Callback when the given info is detected
    public func scan(withHint hint: String,
                     completion: @escaping (Info) -> Void) {
        let viewController = TextScannerViewController<Info, ScanMode>()
        viewController.didDetectInfoAction = { [weak self] info in
            self?.viewController?.presentedViewController?.dismiss(animated: true) {
                completion(info)
            }
        }
        viewController.hint = hint
        let navigationController = UINavigationController(rootViewController: viewController)
        let bottomSheetViewController = BottomSheetViewController(
            viewController: navigationController,
            mode: .ratio(viewController.ratio))
        self.viewController?.present(bottomSheetViewController, animated: true)
    }
}

import AdvancedFoundation
import AdvancedUIKit