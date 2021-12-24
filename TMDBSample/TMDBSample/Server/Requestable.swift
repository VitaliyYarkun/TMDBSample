import Foundation

// MARK: - Constants

enum BaseURLComponents {
    fileprivate static let scheme: String = "https"
    
    enum HostType {
        case `default`
        case image
    }
}

private extension BaseURLComponents.HostType {
    var host: String {
        switch self {
        case .`default`: return "api.themoviedb.org"
        case .image: return "image.tmdb.org"
        }
    }
}

private enum BaseURLPath {
    static let version: String = "4"
}

private enum RequestTimeout {
    static let minimum: TimeInterval = 60.0
}

// MARK: - Protocol

protocol Requestable: TokenManageable {
    // MARK: Properties
    
    var contentType: String { get }
    var accessToken: String? { get }
    
    // MARK: Methods
    
    func baseConfigure(urlComponents: inout URLComponents, hostType: BaseURLComponents.HostType)
    func addHTTPMethod(to request: inout URLRequest)
    func addHTTPHeaders(to request: inout URLRequest)
    func addTimeout(to request: inout URLRequest)
    func addParameters(to request: inout URLRequest) throws
}

// MARK: - Internal

extension Requestable {
    var contentType: String {
        return "application/json"
    }
    
    var accessToken: String? {
        return try? accessToken() ?? nil
    }
    
    func baseConfigure(urlComponents: inout URLComponents, hostType: BaseURLComponents.HostType = .default) {
        urlComponents.scheme = BaseURLComponents.scheme
        urlComponents.host = hostType.host
        switch hostType {
        case .default:
            urlComponents.path = "/" + BaseURLPath.version
        
        case .image:
            urlComponents.path = "/t/p/w500"
        }
    }
    
    func addHTTPMethod(to request: inout URLRequest) {
        preconditionFailure("HTTP method should be added")
    }
    
    func addHTTPHeaders(to request: inout URLRequest) {
        preconditionFailure("HTTP headers should be added")
    }
    
    func addTimeout(to request: inout URLRequest) {
        request.timeoutInterval = RequestTimeout.minimum
    }
    
    func addParameters(to request: inout URLRequest) throws {}
}
