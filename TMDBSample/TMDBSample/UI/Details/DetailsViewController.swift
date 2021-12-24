import AsyncDisplayKit

final class DetailsViewController: ASDKViewController<DetailsViewNode> {
    private let movie: Movie
    
    init(_ movie: Movie) {
        self.movie = movie
        
        super.init(node: DetailsViewNode(movie: movie))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("\(movie.title ?? "")", comment: "")
    }
}

// MARK: - Private

private extension DetailsViewController {}
