import Foundation
/**
 * - Fixme: ⚠️️ I'm not sure we use this anymore as we just use UTC, maybe move to a gist?
 * - Fixme: ⚠️️ I guess we convert back to the users timezone in the presentation layer, so maybe keep around?
 */
extension TimeZone {
   /**
    * The Central European Time (CET) time zone.
    * - Description: The Central European Time (CET) is a time standard used
    *                in Central Europe. It is 1 hour ahead of Coordinated
    *                Universal Time (UTC+1) and is used in countries such as
    *                Germany, France, Italy, and Spain, among others.
    * - Note: The CET time zone is used in countries such as Germany, France, Italy, and Spain, among others.
    */
   internal static let cetTimeZone: TimeZone? = .init(abbreviation: "CET")
   /**
    * The Coordinated Universal Time (UTC) time zone.
    * - Description: The Coordinated Universal Time (UTC) is the primary time
    *                standard by which the world regulates clocks and time. It is
    *                not adjusted for daylight saving time and it is used in many
    *                internet and World Wide Web standards.
    * - Note: Same as GMT, the successor
    * - Note: UTC is the primary time standard by which the world regulates clocks and time. 
    * - Note: It is also known as "Zulu time" or "Z time". 
    * - Note: UTC is the successor to Greenwich Mean Time (GMT) 
    * - Note: It is used as a standard time in aviation, military, and other contexts.
    */
   internal static let utcTimeZone: TimeZone? = .init(abbreviation: "UTC")
   /**
    * The Greenwich Mean Time (GMT) time zone.
    * - Description: Greenwich Mean Time (GMT) is a time standard originally
    *                referring to mean solar time at the Royal Observatory located
    *                in Greenwich, London. It is commonly used in timekeeping and
    *                is the time zone used by the prime meridian of the world.
    * - Note: GMT is a time zone that is used in the United Kingdom and other countries in the winter. 
    * - Note: It is also known as "Zulu time" or "Z time". 
    * - Note: GMT is 0 hours ahead of Coordinated Universal Time (UTC+0)
    * - Note: +0000
    */
   internal static let gmtTimeZone: TimeZone? = .init(abbreviation: "GMT")
   /**
    * The Eastern Standard Time (EST) time zone.
    * - Description: The Eastern Standard Time (EST) is a time zone that is
    *                used in the eastern part of the United States and Canada,
    *                and is 5 hours behind Coordinated Universal Time (UTC-5).
    * - Note: utc -5 nyc time
    * - Note: The EST time zone is used in the eastern part of the United States, including cities such as New York, Washington D.C., and Miami, among others. 
    * - Note: The time zone is 5 hours behind Coordinated Universal Time (UTC-5).
    */
   internal static let estTimeZone: TimeZone? = .init(abbreviation: "EST")
}
/**
 * Date
 */
extension Date {
   /**
    * Returns current time in london gmt / utc +0000
    * - Description: This function returns the current date and time adjusted
    *                to the Coordinated Universal Time (UTC) time zone. It is
    *                useful for converting the local date and time to a
    *                standardized format that is not affected by daylight saving
    *                time or local time zone differences.
    */
   internal func getUTCTimeZoneDate() -> Date? {
      // Calendar.current.dateBySetting(timeZone: .utcTimeZone, of: date)
      guard let utcTimeZone: TimeZone = .utcTimeZone else { return nil } // Get UTC time zone
      return self.convert(from: utcTimeZone, to: TimeZone.current) // Convert date from UTC to current time zone
   }
   /**
    * - Description: This function returns a date adjusted to the current
    *                time zone from a date that represents a time in a different
    *                time zone.
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
    * Converts the date from one time zone to another
    * - Description: This method is used to convert a date from one time zone
    *                to another. It takes the original time zone and the
    *                destination time zone as parameters, and returns the date
    *                converted to the destination time zone.
    * - Parameters:
    *   - timeZone: The time zone of the original date.
    *   - destinationTimeZone: The time zone to convert the date to.
    * - Returns: The converted date, or `nil` if the conversion fails.
    * - Note: from https://stackoverflow.com/a/71146750/5389500
    * - Note: This method is based on the solution provided in this
    *         [Stack Overflow answer](https://stackoverflow.com/a/71146750/5389500).
    * - Remark: This method assumes that the `self` date is in the `timeZone`
    *           time zone. If the `self` date is not in the `timeZone` time zone,
    *           the conversion may produce unexpected results.
    */
//   internal func convert(from timeZone: TimeZone, to destinationTimeZone: TimeZone) -> Date? {
//      let calendar: Calendar = .current // Get current calendar
//      var components: DateComponents = calendar.dateComponents(in: timeZone, from: self) // Get date components in specified time zone
//      components.timeZone = destinationTimeZone // Set destination time zone
//      return calendar.date(from: components) // Return date in destination time zone
//   }
    internal func converted(to timeZone: TimeZone) -> Date {
         let delta = TimeInterval(timeZone.secondsFromGMT(for: self) - TimeZone.current.secondsFromGMT(for: self))
         return addingTimeInterval(delta)
      }
}
