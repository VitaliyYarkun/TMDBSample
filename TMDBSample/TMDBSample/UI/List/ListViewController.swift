import Swinject
import PromiseKit
import AsyncDisplayKit

final class ListViewController: ASDKViewController<ListViewNode> {

    private var moviesAPI: MoviesAPI
    
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
        view.backgroundColor = .green
        
        firstly {
            baseDownload()
        }.done { _ in
            self.node.reloadNode()
        }.catch { error in
            assertionFailure(error.localizedDescription)
        }
    }
}

// MARK: - Private

private extension ListViewController {
    func baseDownload() -> Promise<Void> {
        firstly {
            moviesAPI.requestMovies(listId: 1, page: 1)
        }
    }
}

// MARK: - ListViewNodeDelegate

extension ListViewController: ListViewNodeDelegate {
    func didSelectMovie() {}
}

// MARK: - MoviesServiceDelegate

extension ListViewController: MoviesServiceDelegate {
}
