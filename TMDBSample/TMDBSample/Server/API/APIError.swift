/**
 General type for handling API errors
 */
enum APIError: Error {
    
    /// Used when there is missing data in response body
    case missingBody(reason: String)
}
