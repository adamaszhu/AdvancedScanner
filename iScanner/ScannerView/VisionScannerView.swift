/// The scanner view that can detect texts
///
/// - version: 0.1.0
/// - date: 10/11/21
/// - author: Adamas
@available(iOS 13.0, *)
final class VisionScannerView<Info: InfoType, ScanMode: ScanModeType>: UIView, TextScannerViewType, AVCaptureVideoDataOutputSampleBufferDelegate {

    var didDetectInfoAction: ((Info) -> Void)?

    let ratio = 2160.0 / 3840.0

    /// The scanning mode that the view is under
    private let mode = ScanMode(infoType: Info.self)

    /// Whether the layout has been initialized
    private var isInitialized = false

    /// Cached text detections
    private var detections: [TextDetection] = []

    /// The video session
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
        guard !isInitialized else {
            return
        }
        isInitialized = true
        layer.sublayers?.first?.frame = bounds

        // Setup the mask view
        let maskView = PreviewMaskView(rect: mode.scanningAreaRect(in: bounds),
                                       rectRadius: mode.scanningAreaRadius)
        addSubview(maskView)
        maskView.pinEdgesToSuperview()
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

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            Logger.standard.logError(Self.bufferImageError)
            return
        }

        guard isInitialized else {
            return
        }

        DispatchQueue.main.async {  [weak self] in
            guard let self = self else {
                return
            }
            // Can only get bounds on UI thread
            let rect = self.mode.scanningAreaRect(in: self.bounds)
            let superRect = self.bounds
            DispatchQueue.global(qos: .userInitiated).async {
                self.extractInfo(from: buffer, with: rect, inside: superRect)
            }
        }
    }

    /// Extract info from a given area of an image
    /// - Parameters:
    ///   - buffer: The buffer of the image
    ///   - rect: The area to detect
    ///   - superRect: The whole view size
    private func extractInfo(from buffer: CVImageBuffer, with rect: CGRect, inside superRect: CGRect) {
        var ciImage = CIImage(cvImageBuffer: buffer)

        // Crop the image to what the scanning area is showing
        var rect = rect
        let ratio = ciImage.extent.width / superRect.width
        rect = CGRect(x: rect.minX * ratio,
                      y: rect.minY * ratio,
                      width: rect.width * ratio,
                      height: rect.height * ratio)
        ciImage = ciImage.cropped(to: CIImage.ciRect(for: rect, in: ciImage.extent))

        let textDetector = TextDetector(textTypes: mode.textFormats)
        let detections = textDetector.detect(ciImage, withLanguageCorrection: false)

        // TODO: TEST
        DispatchQueue.main.async {
            let context = CIContext()
            let cgImage = context.createCGImage(ciImage, from: ciImage.extent)
            self.image.image = UIImage(cgImage: cgImage!)
        }
        // TODO: END

        guard !detections.isEmpty else {
            return
        }

        var hasNewDetection = false
        detections.enumerated().forEach { (index, detection) in
            if !self.detections.contains(detection) {
                self.detections.append(detection)
                hasNewDetection = true
            } else if let existingDetection = self.detections.first(where: {$0 == detection}),
                      existingDetection.string != detection.string {
                self.detections.remove(at: index)
                self.detections.insert(detection, at: index)
                hasNewDetection = true
            }
        }

        guard hasNewDetection else {
            return
        }

        DispatchQueue.main.async { [weak self] in
            // Vibration feedback
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            for detection in detections {
                switch detection.textFormat {
                    case TextFormat.creditCardNumber where Info.self == CreditCardInfo.self:
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
    static var videoProcessingQueueLabel: String { "TextScannerProcessingQueue" }
    static var bufferImageError: String { "Cannot get the buffered image." }
}

import AdvancedUIKit
import AdvancedFoundation
import CoreGraphics
import AVFoundation
import CoreImage
