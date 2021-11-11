/// The view controller that contains a scanning function
///
/// - version: 0.1.0
/// - date: 11/10/21
/// - author: Adamas
open class ScannerViewController: UIViewController {

    /// The ratio of the camera view
    public var cameraRatio: Double {
        scannerView.cameraRatio
    }

    /// Set the type of the scanner view
    public var infoType: InfoType = .none {
        didSet {
            scannerView.infoType = infoType
        }
    }

    /// The delegate of the scanning function
    public weak var delegate: ScannerViewDelegate? {
        didSet {
            scannerView.delegate = delegate
        }
    }

    /// The scanner view in the view controller
    private var scannerView: ScannerView = ScannerView()

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
