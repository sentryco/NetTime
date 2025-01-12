import Foundation
//import Logger
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
   // public typealias OnComplete = (´) -> Void
   public typealias OnComplete = (Result<Void, Error>) -> Void

   /**
    * - Description: This is the default completion handler for the
    *                updateTime function. It does nothing when called, and is
    *                used when no other completion handler is provided.
    */
   public static let defaultOnComplete: OnComplete = { _ in } // - Fixme: ⚠️️ add result printing here
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
       synchronizationQueue.sync { // Makes accessing referenceDate and timeGap thread-safe if accessed from multiple threads.
         let possibleDate: Date = Date() // Get the current time
         let ignorableNetworkDelay: TimeInterval = 2 // Define the maximum network delay latency limit
         guard abs(timeGap) > ignorableNetworkDelay else { return possibleDate } // If the absolute value of `timeGap` is less than or equal to `ignorableNetworkDelay`, return `possibleDate`
         return possibleDate.advanced(by: timeGap) // Otherwise, offset `possibleDate` by `timeGap` and return the resulting date
       }
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
    * - Fixme: ⚠️️ Add error to `onComplete` closure, use Result maybe? 👈 This way we can log the error in the caller etc
    * - Fixme: ⚠️️ maybe create proper error enum? 👈
    * fixme: add custom formatter in init, as each url may have different formatter styles etc
    * - Parameter onComplete: Callback when server has responded
    * - Parameter url: - Fixme: ⚠️️ add doc
    * - Parameter queue: - Fixme: ⚠️️ add doc
    */
   public static func updateTime(
       with url: URL? = URL(string: "https://www.apple.com"),
       queue: DispatchQueue = .main,
       onComplete: @escaping OnComplete = defaultOnComplete
   ) {
      // Logger.info("\(Trace.trace()) - 🕐", tag: .db) // Log a message with the current trace and a clock emoji
      guard let url: URL = url/*URL(string: "https://www.apple.com")*/ else { onComplete(.failure(NSError.init(domain: "URL err", code: 0))); return } // Create a URL object from a string, and return if it fails
      let task = URLSession.shared.dataTask(with: url) { (_, response, error) in
           queue.async { // Switch to the main thread
               if let error = error {
                   onComplete(.failure(error)) // Call the completion handler
                   return
               }
                   // Start of Selection
                   guard let httpResponse = response as? HTTPURLResponse else {
                       let error = NSError(
                           domain: "NetTime",
                           code: -1,
                           userInfo: [NSLocalizedDescriptionKey: "Response was not an HTTPURLResponse"]
                       )
                       onComplete(.failure(error))
                       return
                   }
              // Swift.print("httpResponse.allHeaderFields[Date]:  \(httpResponse.allHeaderFields["Date"])")
//              Swift.print("httpResponse.allHeaderFields:  \(httpResponse.allHeaderFields)")
                   guard let stringDate = httpResponse.allHeaderFields["Date"] as? String else {
                       let error = NSError(
                           domain: "NetTime",
                           code: -1,
                           userInfo: [NSLocalizedDescriptionKey: "Failed to get 'Date' from response headers"]
                       )
                       onComplete(.failure(error))
                       return
                   }

                   guard let date = formatter.date(from: stringDate) else {
                       let error = NSError(
                           domain: "NetTime",
                           code: -1,
                           userInfo: [NSLocalizedDescriptionKey: "Failed to parse date from 'Date' header"]
                       )
                       onComplete(.failure(error))
                       return
                   }
               referenceDate = date // Set the reference date to the current date
               onComplete(.success(()))
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
    *                server, and uses the POSIX locale for consistent parsing.
    */
   internal static let formatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.locale = Locale(identifier: "en_US_POSIX")
      formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
      formatter.timeZone = TimeZone(abbreviation: "GMT")
      return formatter
   }()
   
   private static let synchronizationQueue = DispatchQueue(label: "com.yourapp.NTTimeSynchronization")

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
         synchronizationQueue.sync { // Makes accessing referenceDate and timeGap thread-safe if accessed from multiple threads.
            // Calculate the time difference between the current date and the reference date, and assign it to timeGap
            timeGap = Date().distance(to: referenceDate)
          }
      }
   }
}
