import AsyncDisplayKit
import Foundation

// MARK: - Class implementation

final class DetailsPosterCellNode: ASCellNode {
    private var poster: Data? = nil
    private let imageNode: ASImageNode = {
        let node = ASImageNode()
        node.contentMode = .scaleAspectFit
        node.image = UIImage(named: "PosterPlaceholder")
        return node
    }()
    
    // MARK: Lifecycle
    
    init(data: Data?) {
        self.poster = data
        
        super.init()
        
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        backgroundColor = .white
        if let posterData = poster {
            imageNode.image = UIImage(data: posterData)
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        imageNode.style.preferredSize = CGSize(width: 200.0, height: 400.0)
        let stackSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 20.0, justifyContent: .center, alignItems: .center, children: [imageNode])
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0), child: stackSpec)
    }
}
