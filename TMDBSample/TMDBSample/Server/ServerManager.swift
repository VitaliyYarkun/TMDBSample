import Foundation

final class ServerManager {
    static let shared: ServerManager = ServerManager()
    private let sharedSession: URLSession
    
    private init() {
        self.sharedSession = URLSession.shared
    }
    
    func performDataTask(_ request: URLRequest, completionHandler: @escaping ((Data?, URLResponse?, Error?) -> Void)) {
        let dataTask = sharedSession.dataTask(with: request, completionHandler: completionHandler)
        dataTask.resume()
    }
}
