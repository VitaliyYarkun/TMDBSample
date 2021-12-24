import PromiseKit

protocol MoviesAPI: API {
    @discardableResult func requestMovies(listId: Int32, page: Int32) -> Promise<Void>
    @discardableResult func requestPoster(for movieId: Int32, path: String) -> Promise<Void>
}
