import Foundation
/**
 * An enumeration of error types that can occur during network time synchronization.
 */
public enum NetTimeError: Error {
   case invalidURL(URL?)
   case networkError(Error)
   case invalidResponse
   case missingDateHeader
   case dateParsingFailed
   /**
    * A human-readable description of the error.
    */
   public var errorDescription: String? {
      switch self {
      case .invalidURL(let url):
         return "Invalid URL: \(String(describing: url))"
      case .invalidResponse:
         return "Response was not an HTTPURLResponse"
      case .missingDateHeader:
         return "Failed to get 'Date' from response headers"
      case .dateParsingFailed:
         return "Failed to parse date from 'Date' header"
      case .networkError(let error):
         return error.localizedDescription
      }
   }
}
