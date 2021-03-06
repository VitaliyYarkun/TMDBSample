import CoreData
import PromiseKit

protocol Fetchable: CoreDataManageable {
    func isDataBaseEmpty() -> Promise<Bool>
    func fetchMovie(by id: Int32) -> Promise<Movie>
}

// MARK: - Private

private extension Fetchable {
    var mainQueue: DispatchQueue {
        return DispatchQueue.main
    }
}

// MARK: - Internal

extension Fetchable {
    func isDataBaseEmpty() -> Promise<Bool> {
        return firstly { () -> Promise<NSFetchRequest<Movie>> in
            return Promise.value(Movie.fetchRequest())
        }.then(on: mainQueue) { (request) -> Promise<Bool> in
            let count  = try self.coreDataStack.mainContext.count(for: request)
            return Promise.value(count == 0)
        }.recover { _ in 
            return Promise.value(true)
        }
    }
    
    func fetchMovie(by id: Int32) -> Promise<Movie> {
        return firstly { () -> Promise<NSFetchRequest<Movie>> in
            return Promise.value(Movie.fetchRequest())
        }.then(on: mainQueue) { (request) -> Promise<Movie> in
            request.predicate = NSPredicate(format: "%K == %d", #keyPath(Movie.movieId), id)
            guard let movie = try self.coreDataStack.mainContext.fetch(request).first else { throw CoreDataError.missingData(reason: "Fetchable: no movie with id \(id)") }
            return Promise.value(movie)
        }
    }
}
