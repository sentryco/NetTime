import Foundation
import Network
/**
 * - Abstract: Reachability is a utility class that provides methods to check
 *             the availability of internet connectivity.
 * - Description: It performs a network request to a reliable host and
 *                determines if the internet is reachable based on the response.
 */
// internal class Reachability {
   /**
    * Checks to see if internet is reachable
    * - Description: This method checks the reachability of the internet by performing a network request to a reliable host and returns the result through a completion handler.
    * - Note: The reason why we do async: https://stackoverflow.com/a/40764725/5389500
    * - Parameters:
    *   - completionHandler: The closure to call with the result of the network check.
    * ## Example:
    * Self.checkNetwork { Swift.print("Net: \($0)") }
    * - Fixme: ⚠️️ Add result? to print error etc? or just throw error?
    * - Fixme: ⚠️️ Add semaphore with timeout as well, or add timeout some other way? Check with copilots
    */
//   internal static func checkNetwork(completionHandler: @escaping (_ internet: Bool) -> Void) {
//      guard let url: URL = .init(string: "https://www.google.com/") else { completionHandler(false); return; } // Create a URL object for Google's homepage
//      let request: URLRequest = .init(url: url) // Create a URLRequest object with the URL
//      let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { (_: Data?, response: URLResponse?, error: Error?) in // Create a data task with the URLRequest
//         DispatchQueue.main.async { // Switch to the main thread to update the UI
//            if error != nil { // Check if there was an error
//               Swift.print("Error: \(String(describing: error))") // Print the error message
//               completionHandler(false) // Call the completion handler with false
//            } else if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse { // Check if the response is an HTTPURLResponse
//               if httpResponse.statusCode == 200 { completionHandler(true) } // Check if the status code is 200 (OK)
//               else { print("Status-code: \(httpResponse.statusCode)") } // Print the status code if it's not 200
//            }
//         }
//      }
//      task.resume() // Start the data task
//   }
// }
// Handle Timeouts and Retry Logic: Implement a retry mechanism for network checks with exponential backoff.
// Use NWPathMonitor (iOS 12+/macOS 10.14+): Leverage the Network framework's NWPathMonitor for more robust network status monitoring.
internal class Reachability {
   private static let monitor = NWPathMonitor()

   static func checkNetwork(completionHandler: @escaping (_ internet: Bool) -> Void) {
         monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
               completionHandler(true)
            } else {
               completionHandler(false)
            }
            monitor.cancel()
         }
         let queue = DispatchQueue(label: "NetworkMonitor")
         monitor.start(queue: queue)
   }
}
