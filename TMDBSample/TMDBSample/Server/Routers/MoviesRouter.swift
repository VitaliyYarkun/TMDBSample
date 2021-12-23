import Foundation

// MARK: - Enum implementation

enum MoviesRouter {
    
    // MARK: - Cases
    
    case list(id: Int32, page: Int32)
    case poster(path: String)
    
    // MARK: - Properties
    
    var httpMethod: HTTPMethod {
        switch self {
        case .list, .poster:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .list(let id, _):
            return "/list/\(id)"
            
        case .poster(let path):
            return "/\(path)"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .list(_, let page):
            return [URLQueryItem(name: "page", value: "\(page)"),
                    URLQueryItem(name: "sort_by", value: "original_order.asc")]
            
        default:
            return nil
        }
    }
}

// MARK: - Routerable

extension MoviesRouter: Routerable {
    func addHTTPHeaders(to request: inout URLRequest) {
        guard let token = accessToken else { return }
        request.allHTTPHeaderFields = [HTTPHeaderField.contentType.rawValue: contentType, HTTPHeaderField.authorization.rawValue: token]
    }
}
