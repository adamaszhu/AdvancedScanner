/// The text scanner view type that all actual text scanner view should confirm
///
/// - version: 0.1.0
/// - date: 11/10/21
/// - author: Adamas
protocol TextScannerViewType {

    /// The info that the scanner is supporting
    associatedtype Info: InfoType

    /// Callback when some info is detected
    var didDetectInfoAction: ((Info) -> Void)? { get set }

    /// The ratio of the camera view
    var ratio: Double { get }

    /// The hint message
    var hint: String { get set }
}
