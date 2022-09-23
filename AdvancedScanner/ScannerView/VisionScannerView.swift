/// The scanner view that can detect texts
///
/// - version: 0.1.0
/// - date: 10/11/21
/// - author: Adamas
@available(iOS 13.0, *)
final class VisionScannerView<Info: InfoType, ScanMode: ScanModeType>: UIView, TextScannerViewType, AVCaptureVideoDataOutputSampleBufferDelegate {

    var didDetectInfoAction: ((Info) -> Void)?

    let ratio = 2160.0 / 3840.0

    var hint: String = .empty {
        didSet {
            hintLabel.text = hint
        }
    }

    /// The scanning mode that the view is under
    private let mode = ScanMode(infoType: Info.self)

    /// Whether the layout has been initialized
    private var isInitialized = false

    /// Cached text detections
    private var textDetections: [TextDetection] = []

    /// The hint label displayed in the centre of the screen
    private let hintLabel = UILabel()

    /// The stack view used to display detected texts
    private let detectionsStackView = UIStackView()

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

    override func layoutSubviews() {
        super.layoutSubviews()
        guard !isInitialized else {
            return
        }
        isInitialized = true
        layer.sublayers?.first?.frame = bounds

        // Setup the mask view
        let rect = mode.scanningAreaRect(in: bounds)
        let maskView = PreviewMaskView(rect: rect,
                                       rectRadius: mode.scanningAreaRadius)
        addSubview(maskView)
        maskView.pinEdgesToSuperview()

        // Setup the hint label
        hintLabel.textColor = Self.hintColor
        hintLabel.textAlignment = .center
        hintLabel.numberOfLines = 0
        addSubview(hintLabel)
        hintLabel.pinEdgesToSuperview(with: UIEdgeInsets(top: rect.minY,
                                                         left: rect.minX,
                                                         bottom: bounds.height - rect.minY - rect.height,
                                                         right: bounds.width - rect.minX - rect.width))

        // Setup the stack view
        detectionsStackView.axis = .vertical
        detectionsStackView.spacing = Self.stackViewSpacing
        addSubview(detectionsStackView)
        detectionsStackView.pinEdgesToSuperview(with: UIEdgeInsets(top: bounds.height - rect.minY - rect.height + Self.stackViewSpacing,
                                                                   left: rect.minX,
                                                                   bottom: .invalidInset,
                                                                   right: bounds.width - rect.minX - rect.width))
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
        let textDetections = textDetector.detect(ciImage, withLanguageCorrection: false)

        guard !textDetections.isEmpty else {
            return
        }

        // Insert new detection or modify existing detection
        var hasNewDetection = false
        var hasModifiedDetection = false
        textDetections.forEach { textDetection in
            let existingDetection = self.textDetections.first { $0.textFormat.isEqualTo(textDetection.textFormat) }
            if let existingDetection = existingDetection,
               existingDetection.string != textDetection.string {
                existingDetection.string = textDetection.string
                hasModifiedDetection = true
            } else if existingDetection == nil {
                self.textDetections.append(textDetection)
                hasNewDetection = true
            }
        }

        guard hasNewDetection || hasModifiedDetection else {
            return
        }

        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                  let info: Info = self.mode.info(from: self.textDetections) else {
                return
            }
            // Vibration feedback
            if hasNewDetection {
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            }
            self.didDetectInfoAction?(info)
            self.updateDetections()
        }
    }

    /// Display detections in the stack view
    private func updateDetections() {
        detectionsStackView.subviews.forEach { $0.removeFromSuperview() }
        textDetections.forEach { textDetection in
            let label = UILabel()
            label.textColor = Self.hintColor
            label.text = textDetection.textFormat.name + .colon + .space + textDetection.string
            detectionsStackView.addArrangedSubview(label)
        }
    }
}

/// Constants
@available(iOS 13.0, *)
private extension VisionScannerView {
    static var videoProcessingQueueLabel: String { "TextScannerProcessingQueue" }
    static var bufferImageError: String { "Cannot get the buffered image." }
    static var hintColor: UIColor { UIColor.white.withAlphaComponent(0.4) }
    static var stackViewSpacing: CGFloat { 4 }
}

import AdvancedUIKit
import AdvancedFoundation
import CoreGraphics
import AVFoundation
import UIKit
import CoreImage
