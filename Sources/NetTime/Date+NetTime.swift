import Foundation
import Logger
/**
 * Class which will provide the best estimate of the difference in time between the device's system clock and the time returned by a collection of time servers
 * - Description: This class estimates the time difference between the
 *                device's system clock and the time returned by a collection of time
 *                servers. It helps to synchronize the device's time with the server
 *                time, ensuring accurate timekeeping regardless of the user's local
 *                settings.
 * - Note: This class has Unit-tests
 * - Fixme: ⚠️️ If you want to sync your time to a specific server (e.g. your API server)
 * - Fixme: ⚠️️ If for some reason the Date format your HTTP Server returns is different than the one specified
 * ## Examples:
 *  Date.updateTime { // Call when app launches etc
 *     print("☀️ Current Date: \(Date().formatted())")
 *     print("☎️ Server time: \(Date.serverTime.formatted())")
 *  }
 */
@available(macOS 10.15, *)
extension Date {
   /**
    * - Description: This typealias defines a closure type named OnComplete
    *                that takes no parameters and returns no value. It is used
    *                as a completion handler in various functions within this
    *                extension.
    */
   public typealias OnComplete = () -> Void
   /**
    * - Description: This is the default completion handler for the
    *                updateTime function. It does nothing when called, and is
    *                used when no other completion handler is provided.
    */
   public static let defaultOnComplete: OnComplete = {}
   /**
    * Subsequent date getter calls goes here
    * - Abstract: Allows you to make sure your time is synced up to a remote
    *             server regardless of the User's local settings
    * - Description: This property provides the current server time, adjusted
    *                for any time difference between the device's system clock
    *                and the server's clock. It ensures that the time used in
    *                the app is in sync with the server time, regardless of the
    *                user's local settings.
    * - Remark: It does this by performing a one-time-per-session HTTP HEAD
    *           Request to the supplied server, getting a "Base" date, and keep
    *           counting from there - Making sure you're in sync with the remote
    *           server even when the user's clock isn't.
    */
   public static var serverTime: Date {
      let possibleDate: Date = Date() // Get the current time
      let ignorableNetworkDelay: TimeInterval = 2 // Define the maximum network delay latency limit
      guard abs(timeGap) > ignorableNetworkDelay else { return possibleDate } // If the absolute value of `timeGap` is less than or equal to `ignorableNetworkDelay`, return `possibleDate`
      return possibleDate.advanced(by: timeGap) // Otherwise, offset `possibleDate` by `timeGap` and return the resulting date
   }
   /**
    * - Description: This function updates the server time by making a network
    *                call to a specified URL and retrieving the date from the
    *                response headers. It then calculates the time difference
    *                between the server time and the device's system time, and
    *                stores this difference for future use. This ensures that
    *                the app's time is always in sync with the server time,
    *                regardless of the user's local settings.
    * - Remark: Set this at the first opertunity when using the app
    * - Remark: Call this on background queue
    * - Remark: If this is not called e use system time
    * - Fixme: ⚠️️ Add a way to add a custom server URL
    * - Fixme: ⚠️️ Add error to `onComplete` closure, use Result maybe? 👈 This way we can log the error in the caller etc
    * - Parameter onComplete: Callback when server has responded
    */
   public static func updateTime(
       with url: URL? = URL(string: "https://www.apple.com"),
       onComplete: @escaping OnComplete = defaultOnComplete
   ) {
      Logger.info("\(Trace.trace()) - 🕐", tag: .db) // Log a message with the current trace and a clock emoji
      guard let url: URL = url/*URL(string: "https://www.apple.com")*/ else { onComplete(); return } // Create a URL object from a string, and return if it fails
      let task: URLSessionDataTask = URLSession.shared.dataTask(with: url) { (_: Data?, response: URLResponse?, _: Error?) in // Create a data task with the URL
         DispatchQueue.main.async { // Switch to the main thread
            let httpResponse: HTTPURLResponse? = response as? HTTPURLResponse // Cast the response to an HTTPURLResponse object
            if let stringDate: String = httpResponse?.allHeaderFields["Date"] as? String { // Get the "Date" header field from the response
               referenceDate = formatter.date(from: stringDate) ?? .init() // Convert the string date to a Date object using the formatter, or use the current date if it fails
               onComplete() // Call the completion handler
            } else {
               Logger.info("\(Trace.trace()) - Getting reference date from web failed", tag: .net) // Log an error message
               referenceDate = .init() // Set the reference date to the current date
               onComplete() // Call the completion handler
            }
         }
      }
      task.resume() // Start the data task
   }
}
/**
 * Private helpers
 */
@available(macOS 10.15, *)
extension Date {
   /**
    * Date formatter
    * - Description: This is a DateFormatter used to convert the "Date" header
    *                field from the server response into a Date object. It is
    *                configured to match the expected date format from the
    *                server, and uses the current time zone and US English
    *                locale.
    */
   fileprivate static let formatter: DateFormatter = {
      let formatter: DateFormatter = .init() // Create a new date formatter
      formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z" // Set the date format
      formatter.timeZone = TimeZone.current // Set the time zone to the current time zone
      formatter.locale = Locale(identifier: "en-US") // Set the locale to US English
      formatter.dateStyle = .long // Set the date style to long
      formatter.timeStyle = .long // Set the time style to long
      return formatter
   }()
   /**
    * Time-gap between network call and network response
    * - Description: This variable represents the time discrepancy between
    *                initiating the network request and receiving the network
    *                response. It is utilized to synchronize the local time
    *                with the server time.
    */
   fileprivate static var timeGap: TimeInterval = 0
   /**
    * Update time-gap
    * - Description: Calculate the time gap between the current date and the
    *                reference date, and store it in `timeGap`
    */
   fileprivate static var referenceDate: Date = .init() {
      didSet {
         // Calculate the time difference between the current date and the reference date, and assign it to timeGap
         timeGap = Date().distance(to: referenceDate)
      }
   }
}
