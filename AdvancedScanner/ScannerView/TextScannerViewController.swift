/// The view controller that contains a scanning function
///
/// - version: 0.1.0
/// - date: 11/10/21
/// - author: Adamas
open class TextScannerViewController<Info: InfoType, ScanMode: ScanModeType & ScanModePresentable>: UIViewController {

    /// Callback when some info is detected
    public var didDetectInfoAction: ((Info) -> Void)?
    
    /// Add a hint message
    public var hint: String = .empty

    /// The scanner view in the view controller
    private lazy var textScannerView: TextScannerView<Info, ScanMode> = TextScannerView<Info, ScanMode>()

    /// The detected info
    private var info: Info?

    open override func viewDidLoad() {
        super.viewDidLoad()
        textScannerView.didDetectInfoAction = { [weak self] info in
            self?.info = info
        }
        textScannerView.hint = hint
        view.addSubview(textScannerView)
        textScannerView.pinEdgesToSuperview()
        setupNavigationBar()
    }

    /// Setup the navigation bar
    private func setupNavigationBar() {
        setupBackButton()
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: navigationItem.leftBarButtonItem?.title,
            style: navigationItem.leftBarButtonItem?.style ?? .plain,
            target: self, action: #selector(back))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
    }

    /// Close the view controller
    @objc private func back() {
        if let parentViewController = navigationController?.parent as? BottomSheetViewController {
            parentViewController.dismiss(animated: true)
        } else {
            navigationController?.dismiss(animated: true)
        }
    }

    /// Finish the detection
    @objc private func done() {
        if let info = info {
            didDetectInfoAction?(info)
        }
    }
}

extension TextScannerViewController {
    
    /// The default ratio of the camera view
    private static var defaultRatio: Double { 2160.0 / 3840.0 }
    
    /// The ratio of the view controller
    /// - Parameter screen: The device screen
    /// - Returns: The actual ratio
    static func ratio(on screen: UIScreen) -> Double {
        max(defaultRatio, screen.bounds.width / screen.bounds.height)
    }
}

import AdvancedUIKit
import UIKit
