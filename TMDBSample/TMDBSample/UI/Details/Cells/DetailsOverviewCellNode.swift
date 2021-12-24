import AsyncDisplayKit
import Foundation

// MARK: - Class implementation

final class DetailsOverviewCellNode: ASCellNode {
    private let overview: String
    private let overviewTextNode: ASTextNode = ASTextNode()
    
    // MARK: Lifecycle
    
    init(overview: String) {
        self.overview = overview
        
        super.init()
        
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        backgroundColor = .white
        overviewTextNode.attributedText = overview.attributed(with: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        overviewTextNode.style.maxWidth = ASDimensionMake(200)
        let stackSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 20.0, justifyContent: .center, alignItems: .center, children: [overviewTextNode])
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0), child: stackSpec)
    }
}
