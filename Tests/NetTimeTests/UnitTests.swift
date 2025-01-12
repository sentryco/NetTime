import XCTest
@testable import NetTime

final class UnitTests: XCTestCase {
    func testDateFormatterParsing() {
        let dateString = "Sun, 12 Jan 2025 17:44:00 GMT"
        let formatter = Date.formatter
        guard let date = formatter.date(from: dateString) else {
            XCTFail("Failed to parse date string \"\(dateString)\" with formatter")
            return
        }
        // Verify date components
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(abbreviation: "GMT")!
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        XCTAssertEqual(components.year, 2025)
        XCTAssertEqual(components.month, 1)
        XCTAssertEqual(components.day, 12)
        XCTAssertEqual(components.hour, 17)
        XCTAssertEqual(components.minute, 44)
        XCTAssertEqual(components.second, 0)
    }
}
