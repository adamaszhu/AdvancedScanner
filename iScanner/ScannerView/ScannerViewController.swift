/// The view controller that contains a scanning function
///
/// - version: 0.1.0
/// - date: 11/10/21
/// - author: Adamas
open class ScannerViewController<Info>: UIViewController {

    /// The ratio of the camera view
    public var ratio: Double {
        scannerView.ratio
    }

    /// Callback when some info is detected
    public var didDetectInfoAction: ((Info) -> Void)? {
        didSet {
            scannerView.didDetectInfoAction = didDetectInfoAction
        }
    }

    /// The scanner view in the view controller
    public private(set) var scannerView: ScannerView<Info> = ScannerView<Info>()

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scannerView)
        scannerView.pinEdgesToSuperview()
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
