final class ViewController: UIViewController {

    typealias Info = CreditCardInfo
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var messageStackView: UIStackView!

    private lazy var scanner = TextScanner<Info>(viewController: self)

    private lazy var imagePicker: ImagePickerHelper = {
        let imagePicker = ImagePickerHelper()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    @IBAction private func scan(_ sender: Any) {
        scanner.scan(withHint: "Hold the price tag inside the frame.\nIt will be scanned automatically.") { [weak self] info in
            self?.show(info)
        }
    }

    @IBAction func selectPhoto(_ sender: Any) {
        imagePicker.showImagePicker()
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
}

extension ViewController: ImagePickerHelperDelegate {

    func imagePickerHelper(_ imagePickerHelper: ImagePickerHelper,
                           didPick image: UIImage) {
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

    func imagePickerHelper(_ imagePickerHelper: ImagePickerHelper,
                           didCatchError error: String) {}
}

import UIKit
import AdvancedScanner
import AdvancedUIKit
import AdvancedUIKitPhoto
import AdvancedFoundation
