import CoreData
import AsyncDisplayKit

// MARK: - Delegate

protocol ListViewNodeDelegate: AnyObject {
    func didSelectMovie()
}

// MARK: - Class implementation

final class ListViewNode: ASDisplayNode, CoreDataManageable {
    weak var delegate: ListViewNodeDelegate?
    
    private lazy var fetchRequest: NSFetchRequest<Movie> = {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        let titleSort = NSSortDescriptor(key: #keyPath(Movie.title), ascending: true)
        request.sortDescriptors = [titleSort]
        return request
    }()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Movie> = {
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        return controller
    }()
    
    // MARK: Nodes
    
    private let tableNode: ASTableNode = ASTableNode()
    
    // MARK: Lifecycle
    
    override init() {
        super.init()
        
        tableNode.delegate = self
        tableNode.dataSource = self
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = .white
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
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

// MARK: - Internal

extension ListViewNode {
    func reloadNode() {
        tableNode.reloadData()
    }
}

// MARK: - Private

private extension ListViewNode {
}

// MARK: - ASTableDataSource

extension ListViewNode: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return 0 }
        return sectionInfo.numberOfObjects
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let movie = fetchedResultsController.object(at: indexPath)
        
        let cellNodeBlock = { () -> ASCellNode in
            return ListViewCellNode(movie: movie)
        }
        
        return cellNodeBlock
    }
}

// MARK: - ASTableDelegate

extension ListViewNode: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let movie = fetchedResultsController.object(at: indexPath)
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ListViewNode: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableNode.reloadData()
    }
    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch (type) {
//            case .insert:
//                if let indexPath = newIndexPath {
//                    tableNode.insertRows(at: [indexPath], with: .fade)
//                }
//            case .delete:
//                if let indexPath = indexPath {
//                    tableNode.deleteRows(at: [indexPath], with: .fade)
//                }
//            case .update:
//                if let indexPath = indexPath, let node = tableNode.nodeForRow(at: indexPath) as? TMainLeftCellNode {
//                    let product = fetchedResultsController.object(at: indexPath)
//                    node.reloadNode(with: product)
//                }
//        default:
//            break
//        }
//    }
}
