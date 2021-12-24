import AsyncDisplayKit

// MARK: - Delegate

protocol ListViewCellNodeDelegate: AnyObject {
    func requestPoster(movieId: Int32, path: String)
}

// MARK: - Class implementation

final class ListViewCellNode: ASCellNode {
    weak var delegate: ListViewCellNodeDelegate? = nil
    
    private var movie: Movie
    private let titleTextNode: ASTextNode = ASTextNode()
    private let imageNode: ASImageNode = {
        let node = ASImageNode()
        node.contentMode = .scaleAspectFit
        node.image = UIImage(named: "PosterPlaceholder")
        return node
    }()
    
    // MARK: Lifecycle
    
    init(movie: Movie) {
        self.movie = movie
        
        super.init()
        
        automaticallyManagesSubnodes = true
        setupContent(movie)
    }
    
    override func didLoad() {
        super.didLoad()
        backgroundColor = .white
    }
    
    override func didEnterPreloadState() {
        super.didEnterPreloadState()
        
        if movie.posterThumbnail == nil, let path = movie.posterPath {
            delegate?.requestPoster(movieId: movie.movieId, path: path)
        }
    }
    
    override func didEnterVisibleState() {
        super.didEnterVisibleState()
    }
    
    override func didEnterDisplayState() {
        super.didEnterDisplayState()
        if let posterData = movie.posterThumbnail {
            imageNode.image = UIImage(data: posterData)
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        imageNode.style.preferredSize = CGSize(width: 40.0, height: 40.0)
        let stackSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 20.0, justifyContent: .spaceBetween, alignItems: .center, children: [titleTextNode, imageNode])
        stackSpec.style.flexGrow = 1
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0), child: stackSpec)
    }
}

// MARK: - Private

private extension ListViewCellNode {
    func setupContent(_ movie: Movie) {
        setupTextNode(titleTextNode, text: movie.title ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    func setupTextNode(_ textNode: ASTextNode, text: String, attributes: [NSAttributedString.Key: Any]) {
        textNode.truncationMode = .byTruncatingTail
        textNode.pointSizeScaleFactors = [NSNumber(value: 0.95), NSNumber(value: 0.9), NSNumber(value: 0.85), NSNumber(value: 0.8)]
        textNode.attributedText = text.attributed(with: attributes)
    }
}

// MARK: - Internal

extension ListViewCellNode {
    func reloadNode(with movie: Movie) {
        self.movie = movie
        setupContent(movie)
        if let posterData = movie.posterThumbnail {
            imageNode.image = UIImage(data: posterData)
        }
    }
}
