import Foundation

enum APIResponseError: Error {
    case error(description: String?)
}

struct APIResponse {
    let data: Data?
    let urlResponse: URLResponse?
}

extension APIResponse {
    var httpURLResponse: HTTPURLResponse? {
        return urlResponse as? HTTPURLResponse
    }
    
    @discardableResult
    func verify() throws -> APIResponse {
        guard let httpURLResponse = httpURLResponse else { throw APIResponseError.error(description: "APIResponse: missing httpURLResponse") }
      
        switch httpURLResponse.statusCode {
        case 200:
            return self
            
        default:
            throw APIResponseError.error(description: HTTPURLResponse.localizedString(forStatusCode: httpURLResponse.statusCode))
        }
    }
}
