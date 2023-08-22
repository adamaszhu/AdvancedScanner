final class ViewController: UIViewController {
    
    private lazy var scanner = TextScanner<PriceTagInfo, ScanMode>(viewController: self)

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

    private func show(_ info: CreditCardInfo) {
        var message = "Number: \(info.number)"
        if let expiry = info.expiry {
            let expiryString = expiry.string(with: DateFormat.expiryDate)
            message += "\nExpiry: \(expiryString)"
        }
        if let name = info.name {
            message += "\nName: \(name)"
        }
        if let cvn = info.cvn {
            message += "\nCVN: \(cvn)"
        }
        let messageHelper = SystemMessageHelper()
        messageHelper?.showInfo(message,
                               withTitle: "Credit Card",
                               withConfirmButtonName: "OK")
    }

    private func show(_ info: PriceTagInfo) {
        var message = "Price: \(info.price.currencyString() ?? "-")"
        if let barcode = info.barcode {
            message += "\nBarcode: \(barcode)"
        }
        let messageHelper = SystemMessageHelper()
        messageHelper?.showInfo(message,
                               withTitle: "Price Tag",
                               withConfirmButtonName: "OK")
    }
}

extension ViewController: ImagePickerHelperDelegate {

    func imagePickerHelper(_ imagePickerHelper: ImagePickerHelper,
                           didPick image: UIImage) {
        let detector = TextDetector(textTypes: ScanMode.priceTag.textFormats)
        guard let image = CIImage(image: image) else {
            return
        }
        let detections = detector.detect(image, withLanguageCorrection: true)
        let description = detections
            .map(\.string)
            .joined(separator: .linebreak)
        Logger.standard.logInfo("Detections", withDetail: description)
        guard let priceTag = PriceTagInfo(textDetections: detections) else {
            return
        }
        show(priceTag)
    }

    func imagePickerHelper(_ imagePickerHelper: ImagePickerHelper,
                           didCatchError error: String) {}
}

import UIKit
import AdvancedScanner
import AdvancedUIKit
import AdvancedUIKitPhoto
import AdvancedFoundation
