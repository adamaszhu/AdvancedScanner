/// The scanner view that can detect texts
///
/// - version: 0.1.0
/// - date: 10/11/21
/// - author: Adamas
@available(iOS 13.0, *)
final class VisionScannerView<Info>: UIView, ScannerViewType, AVCaptureVideoDataOutputSampleBufferDelegate {

    var didDetectInfoAction: ((Info) -> Void)?

    let ratio = 2160.0 / 3840.0

    private var mode: ScanMode {
        if Info.self == CreditCardInfo.self {
            return .creditCard
        } else {
            return .none
        }
    }

    private let captureSession: AVCaptureSession = {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .hd4K3840x2160
        return captureSession
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    deinit {
        captureSession.stopRunning()
    }

    // TODO: TEST
    private var image: UIImageView = UIImageView(frame: .zero)
    // TODO: END

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.sublayers?.first?.frame = bounds
    }

    /// Initialize the actual scanner view using Vision
    private func initialize() {

        // Add camera input
        guard let device = AVCaptureDevice.default(for: .video),
        let cameraInput = try? AVCaptureDeviceInput(device: device) else {
            return
        }
        captureSession.addInput(cameraInput)

        // Add preview layer
        let preview = AVCaptureVideoPreviewLayer(session: captureSession)
        preview.videoGravity = .resizeAspect
        layer.addSublayer(preview)

        // Setup the mask view
        let maskView = PreviewMaskView(rect: Self.creditCardRect())
        addSubview(maskView)
        maskView.pinEdgesToSuperview()

        // Add video output
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32BGRA)]
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: Self.videoProcessingQueueLabel))
        captureSession.addOutput(videoOutput)

        if let connection = videoOutput.connection(with: .video),
           connection.isVideoOrientationSupported {
            connection.videoOrientation = .portrait
        }

        // Start the session
        captureSession.startRunning()


        //TODO: TEST
        addSubview(image)
        image.contentMode = .scaleAspectFit
        image.pinEdgesToSuperview(with: .init(top: .invalidInset, left: 0, bottom: 0, right: 0))
        if #available(iOS 10.0, *) {
            image.height = 250
        } else {
            // Fallback on earlier versions
        }
        image.backgroundColor = .red
        bringSubviewToFront(image)
        // TODO: END
    }

    static private func creditCardRect(in screen: UIScreen = UIScreen.main) -> CGRect {
        let width = screen.bounds.width * Self.creditCardWidthRatio
        let height = width / Self.creditCardRatio
        let x = screen.bounds.width / 2 - width / 2
        let y = screen.bounds.height / 2 - height / 2 - Self.creditCardOffset
        return CGRect(x: x, y: y, width: width, height: height)
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            Logger.standard.logError(Self.bufferImageError)
            return
        }
        let rect = Self.creditCardRect()
        let superRect = bounds
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.extractInfo(from: buffer, with: rect, inside: superRect)

        }
    }

    private func extractInfo(from buffer: CVImageBuffer, with rect: CGRect, inside superRect: CGRect) {
        let ciImage = CIImage(cvImageBuffer: buffer)
        var rect = rect

        let ratio = ciImage.extent.width / superRect.width

        rect = CGRect(x: rect.minX * ratio,
                      y: rect.minY * ratio,
                      width: rect.width * ratio,
                      height: rect.height * ratio)

        let croppedImage = ciImage.cropped(to: CIImage.ciRect(for: rect, in: ciImage.extent))

        let textDetector = TextDetector(textTypes: mode.textTypes)
        let detections = textDetector.detect(croppedImage, withLanguageCorrection: false)

        // TODO: TEST
        DispatchQueue.main.async {
            let context = CIContext()
            let cgImage = context.createCGImage(croppedImage, from: croppedImage.extent)
                        self.image.image = UIImage(cgImage: cgImage!)
        }
        // TODO: END

        guard !detections.isEmpty else {
            return
        }

        DispatchQueue.main.async { [weak self] in
            // Vibration feedback
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            for detection in detections {
                switch detection.type {
                    case .creditCardNumber where Info.self == CreditCardInfo.self:
                        let info = CreditCardInfo(number: detection.string, name: nil, expiry: nil, cvn: nil)
                        self?.didDetectInfoAction?(info as! Info)
                        self?.captureSession.stopRunning()
                    default:
                        break
                }
            }
        }
    }
}

/// Constants
@available(iOS 13.0, *)
private extension VisionScannerView {
    static var videoProcessingQueueLabel: String { "CreditCardScannerProcessingQueue" }
    static var bufferImageError: String { "Cannot get the buffered image." }
    static var creditCardWidthRatio: Double { 0.8 }
    static var creditCardRatio: Double { 3.0 / 2.0 }
    static var creditCardOffset: CGFloat { 100 }
}

import AdvancedUIKit
import AdvancedFoundation
import CoreGraphics
import AVFoundation
import CoreImage
