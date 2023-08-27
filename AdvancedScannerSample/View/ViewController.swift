final class ViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var messageStackView: UIStackView!
    @IBOutlet private weak var modeSegmentedControl: UISegmentedControl!

    private lazy var scanner = TextScanner(viewController: self)

    private lazy var imagePicker: ImagePickerHelper = {
        let imagePicker = ImagePickerHelper()
        imagePicker.delegate = self
        return imagePicker
    }()

    private var scanMode: ScanMode {
        if let value = modeSegmentedControl.titleForSegment(at: modeSegmentedControl.selectedSegmentIndex),
           let scanMode = ScanMode(rawValue: value) {
            return scanMode
        } else {
            fatalError("The mode is not supported")
        }
    }
    
    @IBAction private func scan(_ sender: Any) {
        let message = "Hold the \(scanMode.rawValue.lowercased()) inside the frame.\nIt will be scanned automatically."
        switch scanMode {
        case .creditCard:
            scanner.scan(withHint: message) { [weak self] (info: CreditCardInfo) in
                self?.show(info)
            }
        case .priceTag:
            scanner.scan(withHint: message) { [weak self] (info: PriceTagInfo) in
                self?.show(info)
            }
        case .receipt:
            scanner.scan(withHint: message) { [weak self] (info: ReceiptInfo) in
                self?.show(info)
            }
        }
    }

    @IBAction private func selectPhoto(_ sender: Any) {
        imagePicker.showImagePicker()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = UIColor(red: 45/255, green: 104/255, blue: 142/255, alpha: 1)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = UIColor.white
    }

    private func show(_ info: InfoType) {
        let message = info.fields
            .map { "\($0): \($1)" }
            .joined(separator: "\n")
        let messageHelper = SystemMessageHelper()
        messageHelper?.showInfo(message,
                               withTitle: "Detected",
                               withConfirmButtonName: "OK")
    }

    private func detect<Info: InfoType>(_: Info.Type, from image: UIImage) {
        let detector = TextDetector(textTypes: Info.textFormats)
        guard let ciImage = CIImage(image: image) else {
            return
        }
        let detections = detector.detect(ciImage, withLanguageCorrection: true)
        messageStackView.arrangedSubviews
            .forEach { $0.removeFromSuperview() }
        detections
            .map(\.string)
            .forEach { detection in
                let label = UILabel()
                label.text = detection
                messageStackView.addArrangedSubview(label)
            }
        imageView.image = image
        guard let info = Info(textDetections: detections) else {
            return
        }
        show(info)
    }
}

extension ViewController: ImagePickerHelperDelegate {

    func imagePickerHelper(_ imagePickerHelper: ImagePickerHelper,
                           didPick image: UIImage) {
        switch scanMode {
        case .creditCard:
            detect(CreditCardInfo.self, from: image)
        case .priceTag:
            detect(PriceTagInfo.self, from: image)
        case .receipt:
            detect(ReceiptInfo.self, from: image)
        }
    }

    func imagePickerHelper(_ imagePickerHelper: ImagePickerHelper,
                           didCatchError error: String) {}
}

import UIKit
import AdvancedScanner
import AdvancedUIKit
import AdvancedUIKitPhoto
import AdvancedFoundation
