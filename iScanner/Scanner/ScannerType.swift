/// The scanner type that all actual scanner should confirm
///
/// - version: 0.1.0
/// - date: 11/10/21
/// - author: Adamas
protocol ScannerType {

    /// The info that the scanner is supporting
    associatedtype Info

    /// Callback when some info is detected
    var didDetectInfoAction: ((Info) -> Void)? { get set }

    /// Start the scanning function
    func scan()
}
