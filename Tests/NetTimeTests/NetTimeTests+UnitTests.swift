import XCTest
@testable import NetTime

extension NetTimeTests {
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
     * Test Successful Time Update with Valid URL
     * This test verifies that Date.updateTime successfully updates the timeGap when provided with a valid URL.
     * Tests that `Date.updateTime` successfully updates the time gap with a valid URL.
     */
    func testUpdateTimeWithValidURL() {
        let expectation = self.expectation(description: "Completion handler invoked")
        Date.updateTime(with: URL(string: "https://www.apple.com")!) { result in
            switch result {
            case .success:
                // Verify that timeGap is set and not zero
                XCTAssertNotEqual(Date.timeGap, 0, "Expected timeGap to be updated")
            case .failure(let error):
                XCTFail("Expected success, but got failure with error: \(error)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
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
    /**
     *  Test Time Gap Calculation with Large Time Difference
     * This test simulates a scenario where the device time is significantly different from the server time and ensures that Date.serverTime correctly adjusts for this difference.
     * Tests the `serverTime` calculation when there's a large time gap.
     */
    func testServerTimeWithLargeTimeGap() {
        // Simulate a large time gap (e.g., 1 hour ahead)
        Date.timeGap = 3600 // 1 hour in seconds
        let adjustedServerTime = Date.serverTime
        let expectedTime = Date().addingTimeInterval(3600)
        XCTAssertEqual(
            adjustedServerTime.timeIntervalSince1970,
            expectedTime.timeIntervalSince1970,
            accuracy: 0.1,
            "Server time should be adjusted by the timeGap"
        )
    }
     
        /**
        Test Date Formatter with Invalid Date String
        This test verifies that the date formatter correctly fails when parsing an invalid date string.
     * Tests that the date formatter fails to parse an invalid date string.
     */
    func testDateFormatterWithInvalidString() {
        let invalidDateString = "Invalid Date String"
        let formatter = Date.formatter
        let date = formatter.date(from: invalidDateString)
        XCTAssertNil(date, "Date formatter should return nil for invalid date strings")
    }
    /**
     * Test Ignorable Network Delay
     * This test verifies that when the timeGap is less than the ignorableNetworkDelay, the serverTime returns the current device time.
     * Tests that when timeGap is less than ignorableNetworkDelay, serverTime returns device time.
     */
    func testServerTimeWithIgnorableDelay() {
        let originalIgnorableDelay = Date.ignorableNetworkDelay
        Date.ignorableNetworkDelay = 2 // Set ignorable delay to 2 seconds

        // Simulate a small time gap
        Date.timeGap = 1.5
        let serverTime = Date.serverTime
        let deviceTime = Date()
        XCTAssertEqual(
            serverTime.timeIntervalSince1970,
            deviceTime.timeIntervalSince1970,
            accuracy: 0.1,
            "Server time should match device time when timeGap is less than ignorable delay"
        )

        // Reset ignorable delay
        Date.ignorableNetworkDelay = originalIgnorableDelay
    }
    /**
     * Test Thread Safety of serverTime Access
     * This test verifies that accessing Date.serverTime from multiple threads does not cause any concurrency issues.
     * Tests that accessing `serverTime` is thread-safe.
     */
    func testServerTimeThreadSafety() {
        Date.timeGap = 60 // 1 minute

        let expectation = self.expectation(description: "Concurrent access")
        expectation.expectedFulfillmentCount = 10

        let queue = DispatchQueue.global(qos: .userInitiated)
        for _ in 0..<10 {
            queue.async {
                let _ = Date.serverTime
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
}
