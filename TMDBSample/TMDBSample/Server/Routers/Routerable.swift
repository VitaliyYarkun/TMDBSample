import Foundation

protocol Routerable: Requestable {
    var httpMethod: HTTPMethod { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    
    func urlRequest() throws ->  URLRequest
}

extension Routerable {
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    func urlRequest() throws ->  URLRequest {
        var urlComponents = URLComponents()
        baseConfigure(urlComponents: &urlComponents)
        urlComponents.path += path
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else { throw NSError(domain: "Invalid url", code: 1, userInfo: nil) }
        
        var request = URLRequest(url: url)
        addHTTPMethod(to: &request)
        addHTTPHeaders(to: &request)
        try addParameters(to: &request)
        addTimeout(to: &request)
        
        return request
    }
    
    func addHTTPMethod(to request: inout URLRequest) {
        request.httpMethod = httpMethod.rawValue
    }
}
