/// The view controller that contains a scanning function
///
/// - version: 0.1.0
/// - date: 11/10/21
/// - author: Adamas
open class TextScannerViewController<Info: InfoType, ScanMode: ScanModeType>: UIViewController {

    /// The ratio of the camera view
    public var ratio: Double {
        textScannerView.ratio
    }

    /// Callback when some info is detected
    public var didDetectInfoAction: ((Info) -> Void)? {
        didSet {
            textScannerView.didDetectInfoAction = didDetectInfoAction
        }
    }

    /// The scanner view in the view controller
    public private(set) var textScannerView = TextScannerView<Info, ScanMode>()

    open override func viewDidLoad() {
        super.viewDidLoad()
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
}

import AdvancedUIKit
