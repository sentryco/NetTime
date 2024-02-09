import XCTest
@testable import NetTime
import Foundation
import NetTime
import Logger

final class NetTimeTests: XCTestCase {
    func testExample() throws {
       Logger.setup(
         config: .plain, // The logger configuration to use
         mode: .init(
            tag: LogTag.allCases, // The log tags to include in the logger mode
            level: LogLevel.allCases.filter({ $0 != .info }) // The log levels to include in the logger mode
         ),
         type: .console // The logger output type to use
       ) // Config Logger, We only want erros and warnings not info (debug is okay)
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
    */
   fileprivate static func time(testCase: XCTestCase) throws {
      try Self.testTimeZoneConversion() // Test time zone conversion functionality of the database
      try Self.serverTime(testCase: testCase) // Test server time functionality of the database
      try Self.testConnectivity(testCase: testCase) // Test connectivity functionality of the database
   }
   /**
    * timezone conversion
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
