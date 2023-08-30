/// The scanner view that can detect texts
///
/// - version: 0.1.0
/// - date: 10/11/21
/// - author: Adamas
final class TextScannerView<Info: InfoType & InfoPresentable>: UIView, AVCaptureVideoDataOutputSampleBufferDelegate {

    /// Callback when some info is detected
    var didDetectInfoAction: ((Info) -> Void)?

    /// The hint message
    var hint: String = .empty {
        didSet {
            hintLabel.text = hint
        }
    }

    /// Whether the layout has been initialized
    private var isInitialized = false

    /// Cached detected info
    private var info: Info?

    /// The hint label displayed in the centre of the screen
    private let hintLabel = UILabel()

    /// The stack view used to display detected texts
    private let detectionsStackView = UIStackView()
    
    /// The latest bounds of the view
    private var latestBounds: CGRect = .zero

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
        self.latestBounds = bounds
        guard !isInitialized else {
            return
        }
        isInitialized = true
        
        // Update the preview layer
        layer.sublayers?.first?.frame = bounds

        // Setup the mask view
        let rect = Info.scanningAreaRect(in: bounds)
        let maskView = PreviewMaskView(rect: rect,
                                       rectRadius: Info.scanningAreaRadius)
        addSubview(maskView)
        maskView.pinEdgesToSuperview()

        // Setup the hint label
        hintLabel.textColor = Self.hintColor
        hintLabel.textAlignment = .center
        hintLabel.numberOfLines = 0
        addSubview(hintLabel)
        let hintEdgeInsets = UIEdgeInsets(top: rect.minY,
                                          left: rect.minX,
                                          bottom: bounds.height - rect.minY - rect.height,
                                          right: bounds.width - rect.minX - rect.width)
        hintLabel.pinEdgesToSuperview(with: hintEdgeInsets)

        // Setup the stack view
        detectionsStackView.axis = .vertical
        detectionsStackView.spacing = Self.stackViewSpacing
        addSubview(detectionsStackView)
        let detectionsEdgeInsets = UIEdgeInsets(top: bounds.height - rect.minY - rect.height + Self.stackViewSpacing,
                                                left: rect.minX,
                                                bottom: .invalidInset,
                                                right: bounds.width - rect.minX - rect.width)
        detectionsStackView.pinEdgesToSuperview(with: detectionsEdgeInsets)
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
        videoOutput.setSampleBufferDelegate(self, queue: Self.videoDispatchQueue)
        captureSession.addOutput(videoOutput)

        if let connection = videoOutput.connection(with: .video),
           connection.isVideoOrientationSupported {
            connection.videoOrientation = .portrait
        }

        // Start the session
        Self.videoDispatchQueue.async { [weak self] in
            self?.captureSession.startRunning()
        }
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            Logger.standard.logError(Self.bufferImageError)
            return
        }

        guard isInitialized else {
            return
        }

        let rect = Info.scanningAreaRect(in: latestBounds)
        extractInfo(from: buffer, in: rect, inside: latestBounds)
    }

    /// Extract info from a given area of an image
    /// - Parameters:
    ///   - buffer: The buffer of the image
    ///   - rect: The area to detect
    ///   - superRect: The whole view size
    private func extractInfo(from buffer: CVImageBuffer, in rect: CGRect, inside superRect: CGRect) {
        var ciImage = CIImage(cvImageBuffer: buffer)

        // Crop the image to what the scanning area is showing
        let ratio = ciImage.extent.width / superRect.width
        let rect = CGRect(x: rect.minX * ratio,
                      y: rect.minY * ratio,
                      width: rect.width * ratio,
                      height: rect.height * ratio)
        ciImage = ciImage.cropped(to: CIImage.ciRect(for: rect, in: ciImage.extent))

        let textDetector = TextDetector(textTypes: Info.textFormats)
        let textDetections = textDetector
            .detect(ciImage, withLanguageCorrection: Info.shouldCorrectLanguage)
            .filter { $0.textFormat != nil }

        var hasNewDetection = false
        if info != nil {
            hasNewDetection = info?.update(with: textDetections) ?? false
        } else {
            info = Info(textDetections: textDetections)
            hasNewDetection = info != nil
        }

        guard hasNewDetection else {
            return
        }

        DispatchQueue.main.async { [weak self] in
            self?.handleNewDetection()
        }
    }
    
    /// Handle a new text detection
    /// - Parameter isNewDetection: Whether or not new text has been detected
    private func handleNewDetection() {
        guard let info = info else {
            return
        }
        // Vibration feedback
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        didDetectInfoAction?(info)
        updateDetections()
    }

    /// Display detections in the stack view
    private func updateDetections() {
        hintLabel.isHidden = true
        detectionsStackView.subviews.forEach { $0.removeFromSuperview() }
        info?.fields.forEach { field in
            let label = UILabel()
            label.textColor = Self.hintColor
            label.text = field.key + .colon + .space + field.value
            detectionsStackView.addArrangedSubview(label)
        }
    }
}

/// Constants
private extension TextScannerView {
    static var videoProcessingQueueLabel: String { "TextScannerProcessingQueue" }
    static var bufferImageError: String { "Cannot get the buffered image." }
    static var hintColor: UIColor { UIColor.white.withAlphaComponent(0.4) }
    static var stackViewSpacing: CGFloat { 4 }
    static var videoDispatchQueue: DispatchQueue { DispatchQueue(label: Self.videoProcessingQueueLabel) }
}

import AdvancedUIKit
import AdvancedFoundation
import CoreGraphics
import AVFoundation
import UIKit
import CoreImage
