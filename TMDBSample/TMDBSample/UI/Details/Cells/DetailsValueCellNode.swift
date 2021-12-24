import AsyncDisplayKit
import Foundation

// MARK: - Class implementation


// TODO: Should be updated to handle general use cases
final class DetailsValueCellNode: ASCellNode {
    /// Should be changed to Any type in the future
    private let value: Double
    private let valueTextNode: ASTextNode = ASTextNode()
    
    // MARK: Lifecycle
    
    init(value: Double) {
        self.value = value
        
        super.init()
        
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        backgroundColor = .white
        valueTextNode.attributedText = "\(value)".attributed(with: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        valueTextNode.style.maxWidth = ASDimensionMake(200)
        let stackSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 20.0, justifyContent: .center, alignItems: .center, children: [valueTextNode])
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0), child: stackSpec)
    }
}
