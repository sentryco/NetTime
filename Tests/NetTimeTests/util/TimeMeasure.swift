import Foundation
/**
 * TimeMeasure is a utility class for measuring the execution time of code blocks.
 * It provides static methods to measure the time taken for synchronous operations
 * and return the duration in seconds. This can be useful for performance testing
 * or ensuring that certain operations do not exceed a time budget.
 */
internal final class TimeMeasure {
   /**
    * The number of nano-seconds in a second
    * - Description: This constant is used to convert nanoseconds to seconds for time measurement purposes.
    */
   fileprivate static let nanoToSecond: Double = 1_000_000_000 
   /**
    * A closure that takes no parameters and returns nothing
    * - Description: This typealias defines a closure type named Operation that takes no parameters and throws an error if it fails. It is used in the timeElapsed methods to measure the execution time of a given operation.
    */
   internal typealias Operation = () throws -> Void 
   /**
    * Measures how long a closure takes to complete
    * - Description: This method measures the execution time of a given closure in seconds. It takes a closure as a parameter, executes it, and returns the time taken for the closure to complete its execution.
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
    * - Description: This method measures the execution time of a given closure and returns the result of the closure along with the time taken. It is useful for performance testing and optimization by allowing developers to quantify the duration of code execution.
    * - Note: so you can time individual times etc
    * - Parameter closure: The closure whose execution time is being measured. It returns a value of type T.
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
