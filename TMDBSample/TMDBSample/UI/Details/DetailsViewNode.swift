import AsyncDisplayKit

// MARK: - Class implementation

final class DetailsViewNode: ASDisplayNode {
    private let dataSource: [CellType]
    private let tableNode: ASTableNode = ASTableNode()
    
    // MARK: Lifecycle
    
    init(movie: Movie) {
        self.dataSource = [.poster(data: movie.poster?.poster), .overview(value: movie.overview), .rate(value: movie.voteAverage)]
        
        super.init()
        
        tableNode.dataSource = self
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = .white
    }
    
    // MARK: Methods
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        // Table
        tableNode.style.flexGrow = 1.0
        
        // General
        let stackSpec = ASStackLayoutSpec(direction: .vertical, spacing: 20.0, justifyContent: .start, alignItems: .center, children: [tableNode])
        stackSpec.style.preferredSize = constrainedSize.max
        return stackSpec
    }
}

// MARK: - Private

private extension DetailsViewNode {
    enum  CellType {
        case poster(data: Data?)
        case overview(value: String?)
        case rate(value: Double)
    }
}

// MARK: - ASTableDataSource

extension DetailsViewNode: ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let type = dataSource[indexPath.row]
        
        let cellNodeBlock = { () -> ASCellNode in
            switch type {
            case .poster(let data): return DetailsPosterCellNode(data: data)
            case .overview(let overview): return DetailsOverviewCellNode(overview: overview ?? "")
            case .rate(let value): return DetailsValueCellNode(value: value)
            }
        }
        
        return cellNodeBlock
    }
}

