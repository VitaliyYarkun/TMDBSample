import Swinject
import PromiseKit
import AsyncDisplayKit

final class ListViewController: ASDKViewController<ListViewNode> {

    override init() {
        super.init(node: ListViewNode())
        node.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }
}

// MARK: - ListViewNodeDelegate

extension ListViewController: ListViewNodeDelegate {
    func didSelectMovie() {}
}
