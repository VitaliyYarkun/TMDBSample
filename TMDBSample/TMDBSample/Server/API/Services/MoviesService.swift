import PromiseKit

protocol MoviesServiceDelegate: AnyObject {}

final class MoviesService: BaseService, MoviesAPI {
    weak var delegate: MoviesServiceDelegate? = nil
}

// MARK: - MoviesAPI

extension MoviesService {
    func requestMovies(listId: Int32, page: Int32) -> Promise<Void> {
        firstly { () -> Promise<URLRequest> in
            Promise.value(try MoviesRouter.list(id: listId, page: page).urlRequest())
        }.then(on: defaultBackgroundQueue) { (request) -> Promise<APIResponse> in
            self.response(for: request)
        }.then(on: mainQueue) { (response) -> Promise<Void> in
            try response.verify()
            guard let data = response.data else { throw APIError.missingBody(reason: "MoviesService: missing data in response for requestMovies")}
            let _ = try self.decoder.decode(MoviesResponseModel.self, from: data)
            self.saveCoreDataContext()
            return Promise.value(())
        }
    }

    func requestPoster(for movieId: Int32, path: String) -> Promise<Void> {
        firstly {
            Promise.value(try MoviesRouter.poster(path: path).urlRequest(.image))
        }.then(on: defaultBackgroundQueue) { (request) -> Promise<APIResponse> in
            self.response(for: request)
        }.then(on: mainQueue) { (response) -> Promise<(Data, Movie)> in
            try response.verify()
            guard let data = response.data else { throw APIError.missingBody(reason: "MoviesService: missing data in response for requestPoster")}
            return when(fulfilled: Promise.value(data), self.fetchMovie(by: movieId))
        }.then(on: mainQueue) { (data, movie) -> Promise<Void> in
            movie.posterThumbnail = data.imageScaledToHeight(height: 60.0)
            let poster = MoviePoster(context: self.coreDataStack.mainContext)
            poster.poster = data
            movie.poster = poster
            self.saveCoreDataContext()
            return Promise.value(())
        }
    }
}
