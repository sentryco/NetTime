import Foundation

internal final class TimeMeasure {
   /**
    * The number of nano-seconds in a second
    */
   fileprivate static let nanoToSecond: Double = 1_000_000_000 
   /**
    * A closure that takes no parameters and returns nothing
    */
   internal typealias Operation = () throws -> Void 
   /**
    * Measures how long a closure takes to complete
    * - Note: This method is great for UnitTesting
    * - Note: it's also possible to use. `let startTime = CFAbsoluteTimeGetCurrent(); CFAbsoluteTimeGetCurrent() - startTime`
    * - Fixme: ⚠️️ Add param comment
    * ## Examples:
    * print("\(timeElapsed { sleep(2.2) })") // 2.20000
    */
   internal static func timeElapsed(_ closure: Operation) rethrows -> Double {
      let start: DispatchTime = .now() // Get the current time
      try closure() // Call the closure
      let end: DispatchTime = .now() // Get the current time again
      let diff: UInt64 = end.uptimeNanoseconds - start.uptimeNanoseconds // Calculate the difference between the two times
      return Double(diff) / nanoToSecond // Convert the difference to seconds and return it
   }
   /**
    * A time-measure that prints the time used, and returns the value of payload etc
    * - Note: so you can time individual times etc
    * fix: add param comment
    * timeElapsed { sleep(2.2) }.time // 2.20000
    */
   internal static func timeElapsed<T>(_ closure: () throws -> T) rethrows -> (value: T, time: Double) {
      let start: DispatchTime = .now() // Get the current time
      let retVal: T = try closure() // Call the closure and store the return value
      let end: DispatchTime = .now() // Get the current time again
      let diff: UInt64 = end.uptimeNanoseconds - start.uptimeNanoseconds // Calculate the difference between the two times
      let time: Double = .init(diff) / nanoToSecond // Convert the difference to seconds
      return (retVal, time) // Return a tuple containing the return value and the time taken
   }
}
