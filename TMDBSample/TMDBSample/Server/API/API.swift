import PromiseKit

protocol API: AnyObject {
    func response(for request: URLRequest) -> Promise<APIResponse>
}

extension API {
    func response(for request: URLRequest) -> Promise<APIResponse> {
        return Promise { seal in
            ServerManager.shared.performDataTask(request) { data, urlResponse, error in
                let response = APIResponse(data: data, urlResponse: urlResponse)
                seal.resolve(response, error)
            }
        }
    }
}
