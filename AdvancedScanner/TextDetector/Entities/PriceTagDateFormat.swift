/// Date formats supported by a price tag
///
/// - version: 0.1.0
/// - date: 26/08/23
/// - author: Adamas
enum PriceTagDateFormat: String, CaseIterable {
    case shortDashCalendarDate = "dd-MM-yy"
}

extension PriceTagDateFormat: DateFormatType {

    var pattern: String {
        rawValue
    }
}

import AdvancedFoundation
