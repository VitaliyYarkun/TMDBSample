import PromiseKit

protocol MoviesAPI: API {
    func requestMovies(listId: Int32, page: Int32) -> Promise<Void>
    func requestPoster(for movieId: Int32, path: String) -> Promise<Void>
}
