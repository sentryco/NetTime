import XCTest
@testable import NetTime

final class UnitTests: XCTestCase {
   /**
    * - Fixme: ⚠️️ add doc
    */
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
   /**
    * Unit Tests for Error Conditions
    * Add unit tests that cover error scenarios, such as network failures or date parsing failures, to ensure your error handling works as expected.
    * - Fixme: ⚠️️ add doc
    */
    func testUpdateTimeWithInvalidURL() {
        let expectation = self.expectation(description: "Completion handler invoked")
        Date.updateTime(with: URL(string: "invalid_url")!) { result in
            if case .failure(let error) = result {
                XCTAssertNotNil(error)
            } else {
                XCTFail("Expected failure when using an invalid URL")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
   /**
    * - Fixme: ⚠️️ add doc
    */
    func testTimeGapCalculation() {
         // Set a known timeGap
         Date.timeGap = 60 // 1 minute
         let adjustedServerTime = Date.serverTime
         let expectedTime = Date().addingTimeInterval(60)
         XCTAssertEqual(
             adjustedServerTime.timeIntervalSince1970,
             expectedTime.timeIntervalSince1970,
             accuracy: 0.1
         )
     }
}
