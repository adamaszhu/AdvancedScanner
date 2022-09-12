/// The scanner type that all actual scanner should confirm
///
/// - version: 0.1.0
/// - date: 11/10/21
/// - author: Adamas
protocol ScannerType {

    /// The info that the scanner is supporting
    associatedtype Info

    /// Start the scanning function
    func scan(completion: @escaping (Info) -> Void)
}
