import XCTest
@testable import NetTime
import Foundation
import NetTime
import Logger

final class NetTimeTests: XCTestCase {
    func testExample() throws {
       Logger.setup( // Initialize the Logger with the specified configuration and mode, excluding the 'info' log level
         config: .plain, // The logger configuration to use
         mode: .init( // Initialize the logger mode with specific tags and levels
            tag: LogTag.allCases, // The log tags to include in the logger mode
            level: LogLevel.allCases.filter({ $0 != .info }) // The log levels to include in the logger mode
         ),
         type: .console // The logger output type to use
       )
       do {
          try Self.time(testCase: self) // Testing time (NTPTime, Reachability)
       } catch {
          Swift.print("⚠️️ Test err: \(error)")
          XCTFail(error.localizedDescription)
       }
    }
}
/**
 * - Note: More on network unit testing: https://nshipster.com/xctestcase/
 * - Remark: can't be static because async?
 */
extension NetTimeTests {
   /**
    * Testing time
    * - Description: This method validates the functionality of time-related features such as time zone conversion, server time synchronization, and network connectivity within the NetTime framework.
    */
   fileprivate static func time(testCase: XCTestCase) throws {
      try Self.testTimeZoneConversion() // Test time zone conversion functionality of the database
      try Self.serverTime(testCase: testCase) // Test server time functionality of the database
      try Self.testConnectivity(testCase: testCase) // Test connectivity functionality of the database
   }
   /**
    * timezone conversion
    * - Description: This method tests the functionality of time zone conversion within the NetTime framework. It validates the conversion of local time to UTC and vice versa, ensuring the accuracy of these conversions.
    * - Remark: This is less relevant, but explains how timezone works etc. As we always format to users timezone and save in UTC in DB
    */
   static func testTimeZoneConversion() throws {
      // Swift.print("TimeZone.current: \(TimeZone.current)")
      // Swift.print("TimeZone.utcTimeZone: \(String(describing: TimeZone.utcTimeZone))")
      Swift.print("Local time: \(Date().description)") // Print the local time
      guard let utcDate: Date = .init().getUTCTimeZoneDate() else {
         throw NSError(domain: "Err, get utc", code: 0)
      } // Get the UTC date
      Swift.print("🏴󠁧󠁢󠁥󠁮󠁧󠁿 UTC Date: \(utcDate.formatted())") // Print the formatted UTC date
      // - Fixme: ⚠️️ store in Database etc
      guard let presentationDate: Date = utcDate.getCurrentTimeZoneDate(timeZone: .utcTimeZone) else {
         throw NSError(domain: "Err, get utc", code: 0)
      } // Get the presentation date
      Swift.print("🎯 presentationDate: \(presentationDate.formatted())") // Print the formatted presentation date
   }
   /**
    * Reachability test (makes sure unit test has network etc)
    * - Description: This method tests the network connectivity of the device. It uses the Reachability utility class to check if the internet is reachable. This is important for unit tests that require network access.
    * - Fixme: ⚠️️ Add a timer on the reachability, how long it takes etc
    */
   static func testConnectivity(testCase: XCTestCase) throws {
      Swift.print("testConnectivity")
      let exception: XCTestExpectation = testCase.expectation(description: "asynchronous request")
      DispatchQueue.global(qos: .background).async { // Perform the check on a background queue
         Reachability.checkNetwork { // Check the network connectivity
            Swift.print("Reachability: \($0 ? "✅" : "🚫")") // Print whether the network is reachable
            XCTAssertTrue($0) // Assert that the network is reachable
            exception.fulfill() // Fulfill the expectation
         }
      } // End of the background queue block
      testCase.waitForExpectations(timeout: 15.0) // Sometimes it just takes some time to finish 🤔
   }
   /**
    * Server time
    * - Description: This method tests the accuracy and reliability of the server time synchronization within the NetTime framework. It ensures that the time reported by the server is correctly retrieved and formatted, reflecting the precise current time according to the server's clock.
    * - Fixme: ⚠️️⚠️️ Format time with milli / nano seconds etc -> See history date formater
    * - Remark: Date is stored in Swift as UTC time, i.e. as at longitude 0.0 - which used to be called Greenwich Mean Time. It doesn't take into account your timezone, nor any Summertime adjustment. When you display the time to the user in your code, via UIKit or SwiftUI, you use a DateFormatter
    */
   static func serverTime(testCase: XCTestCase) throws {
      let exception: XCTestExpectation = testCase.expectation(description: "asynchronous request")
      DispatchQueue.global(qos: .background).async { // Run the following code on a background queue
         Date.updateTime { // Update the current time
            Swift.print("🌍 TimeZone.current: \(TimeZone.current.description)") // Print the current time zone
            Swift.print("☀️ Current Date: \(Date().formatted())") // Print the current date
            Swift.print("☎️ Server time: \(Date.serverTime.formatted())") // Print the server time
            exception.fulfill() // Fulfill the exception
         }
      }
      testCase.waitForExpectations(timeout: 15.0) // Sometimes it just takes some time to finish 🤔
   }
}
