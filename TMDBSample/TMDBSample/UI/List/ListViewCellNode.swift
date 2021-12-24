import AsyncDisplayKit

private enum Size {
    static let cellHeight: CGFloat = 60.0
}

// MARK: - Class implementation

final class ListViewCellNode: ASCellNode {
    private var movie: Movie
    private let titleTextNode: ASTextNode = ASTextNode()
    private let imageNode: ASImageNode = {
        let node = ASImageNode()
        node.contentMode = .scaleAspectFit
        node.image = UIImage(named: "TImagePlaceholder")
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
    
    // MARK: Methods
    
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
        titleTextNode.style.width = ASDimensionMake(constrainedSize.max.width * 0.2)
        titleTextNode.style.maxHeight = ASDimensionMake(Size.cellHeight * 0.7)
        let stackSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 20.0, justifyContent: .spaceBetween, alignItems: .center, children: [titleTextNode, imageNode])
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
    }
}
