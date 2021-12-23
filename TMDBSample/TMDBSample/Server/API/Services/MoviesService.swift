import PromiseKit

protocol MoviesServiceDelegate: AnyObject {}

final class MoviesService: BaseService {
    weak var delegate: MoviesServiceDelegate? = nil
}

// MARK: - MoviesAPI

extension MoviesService: MoviesAPI {
    func requestMovies(listId: Int32, page: Int32) -> Promise<Void> {
        firstly { () -> Promise<URLRequest> in
            Promise.value(try MoviesRouter.list(id: listId, page: page).urlRequest())
        }.then(on: defaultBackgroundQueue) { (request) -> Promise<APIResponse> in
            self.response(for: request)
        }.then(on: defaultBackgroundQueue) { (response) -> Promise<Void> in
            try response.verify()
            guard let data = response.data else { throw APIError.missingBody(reason: "MoviesService: missing data in response for requestMovies")}
            let _ = try self.decoder.decode(MoviesResponseModel.self, from: data)
            self.saveCoreDataContext()
            return Promise.value(())
        }
    }

    func requestPoster(for movieId: Int32, path: String) -> Promise<Void> {
        return Promise.value(())
    }
}
