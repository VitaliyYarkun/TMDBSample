import Swinject
import PromiseKit
import AsyncDisplayKit

final class ListViewController: ASDKViewController<ListViewNode>, Fetchable {
    private var moviesAPI: MoviesAPI
    
    private var page: Int32 = 1
    
    init(_ container: Container) {
        let service = container.resolve(MoviesService.self)!
        self.moviesAPI = service
        
        super.init(node: ListViewNode())
        
        node.delegate = self
        service.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("Movies", comment: "")
        
        firstly {
            baseDownloadIfNeeded()
        }.done { _ in
            self.node.reloadNode()
        }.catch { error in
            assertionFailure(error.localizedDescription)
        }
    }
}

// MARK: - Private

private extension ListViewController {
    func baseDownloadIfNeeded() -> Promise<Void> {
        firstly {
            isDataBaseEmpty()
        }.then { isEmpty in
            return isEmpty ? self.moviesAPI.requestMovies(listId: 1, page: self.page) : Promise.value(())
        }
    }
}

// MARK: - ListViewNodeDelegate

extension ListViewController: ListViewNodeDelegate {
    func didSelectMovie(_ movie: Movie) {
        navigationController?.pushViewController(DetailsViewController(movie), animated: true)
    }
    
    func requestNewBatchOfMovies() {
        page += 1
        moviesAPI.requestMovies(listId: 1, page: page)
    }
    
    func requestPoster(movieId: Int32, path: String) {
        moviesAPI.requestPoster(for: movieId, path: path)
    }
}

// MARK: - MoviesServiceDelegate

extension ListViewController: MoviesServiceDelegate {}
