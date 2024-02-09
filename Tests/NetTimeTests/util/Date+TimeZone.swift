import Foundation
// Fix: im not sure we use this anymore as we jsut use UTC, maybe move to a gist?
extension TimeZone {
   /**
    * The Central European Time (CET) time zone.
    * The CET time zone is used in countries such as Germany, France, Italy, and Spain, among others.
    */
   internal static let cetTimeZone: TimeZone? = .init(abbreviation: "CET")
   /**
    * The Coordinated Universal Time (UTC) time zone.
    * Same as GMT, the successor
    * UTC is the primary time standard by which the world regulates clocks and time. 
    * It is also known as "Zulu time" or "Z time". 
    * UTC is the successor to Greenwich Mean Time (GMT) 
    * It is used as a standard time in aviation, military, and other contexts.
    */
   internal static let utcTimeZone: TimeZone? = .init(abbreviation: "UTC")
   /**
    * The Greenwich Mean Time (GMT) time zone.
    * GMT is a time zone that is used in the United Kingdom and other countries in the winter. 
    * It is also known as "Zulu time" or "Z time". 
    * GMT is 0 hours ahead of Coordinated Universal Time (UTC+0)
    * +0000
    */
   internal static let gmtTimeZone: TimeZone? = .init(abbreviation: "GMT")
   /**
    * The Eastern Standard Time (EST) time zone.
    * utc -5 nyc time
    * The EST time zone is used in the eastern part of the United States, including cities such as New York, Washington D.C., and Miami, among others. 
    * The time zone is 5 hours behind Coordinated Universal Time (UTC-5).
    */
   internal static let estTimeZone: TimeZone? = .init(abbreviation: "EST")
}
/**
 * Date
 */
extension Date {
   /**
    * Returns current time in london gmt / utc +0000
    */
   internal func getUTCTimeZoneDate() -> Date? {
      // Calendar.current.dateBySetting(timeZone: .utcTimeZone, of: date)
      guard let utcTimeZone: TimeZone = .utcTimeZone else { return nil } // Get UTC time zone
      return self.convert(from: utcTimeZone, to: TimeZone.current) // Convert date from UTC to current time zone
   }
   /**
    * - Note: returns a time from another timezone represented in the current timezone
    * - Parameter timeZone: the timezone self represent
    * - Returns: adjusted date
    */
   internal func getCurrentTimeZoneDate(timeZone: TimeZone?) -> Date? {
      guard let timeZone: TimeZone = timeZone else { return nil } // Check if time zone exists
      // Calendar.current.dateBySetting(timeZone: .currentTimeZone, of: date)
      // guard let dateTimeZone: TimeZone = self.calendar?.timeZone else { return nil }
      return self.convert(from: TimeZone.current, to: timeZone) // Convert date from current time zone to specified time zone
   }
   /**
    * Converts the date from one time zone to another.
    * - Parameters:
    *   - timeZone: The time zone of the original date.
    *   - destinationTimeZone: The time zone to convert the date to.
    * - Returns: The converted date, or `nil` if the conversion fails.
    * - Note: from https://stackoverflow.com/a/71146750/5389500
    * - Note: This method is based on the solution provided in this [Stack Overflow answer](https://stackoverflow.com/a/71146750/5389500).
    * - Remark: This method assumes that the `self` date is in the `timeZone` time zone. If the `self` date is not in the `timeZone` time zone, the conversion may produce unexpected results.
    */
   internal func convert(from timeZone: TimeZone, to destinationTimeZone: TimeZone) -> Date? {
      let calendar: Calendar = .current // Get current calendar
      var components: DateComponents = calendar.dateComponents(in: timeZone, from: self) // Get date components in specified time zone
      components.timeZone = destinationTimeZone // Set destination time zone
      return calendar.date(from: components) // Return date in destination time zone
   }
}
